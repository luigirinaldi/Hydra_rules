from collections import defaultdict
import re
import os
import shutil
import sys
import json

from llvmlite import binding as llvm

def extract_width_annotations(ir_text: str):
    """
    Extract width annotations from pseudo-LLVM IR and return cleaned IR with width map.

    Args:
        ir_text: The IR text containing width annotations

    Returns:
        A tuple of (rw_map, width_map) where:
        - rw_map: Dictionary mapping the final return width
        - width_map: Dictionary mapping variable names to their width expressions
    """
    width_map: dict[str, str] = {}
    lines = ir_text.split('\n')
    cleaned_lines = []

    precond_var, lhs_var, rhs_w = (None, None, None)

    symbolic_vars = []
    ssa_vars = []

    for line in lines:
        if line == '':
            continue
        width_match = re.match(r'^\s*(%\w+):i(\d+)\s+=\s+(.+?)(?:\s*;.*)?$', line)

        if width_match:
            width_var = width_match.group(1)  # e.g., %2
            width_val = width_match.group(2).strip()
            width_map[width_var] = width_val
            if ' var ' in line:
                symbolic_vars.append(width_var)
            ssa_vars.append(width_var)
            cleaned_lines.append(line.replace(f':i{width_val}', ''))
        elif 'pc' in line:
            if '1:i1' not in line:
                raise ValueError("missing 1:i1")
            precond_var = line.replace('pc', '').replace('1:i1', '').strip()
        elif 'infer' in line:
            lhs_var = line.replace('infer', '').strip()
            assert lhs_var in ssa_vars, f"unkown {lhs_var}"
        elif 'result' in line:
            rhs_var = line.replace('result', '').strip()
            if rhs_var not in ssa_vars:
                # This is the case where the rhs is a constant
                const_match = re.match(r'(\d+):i\d+', rhs_var)
                assert const_match is not None, f"{rhs_var} not a constant, don't know what it is"
                rhs_w = const_match.group(1)
            else:
                rhs_w = width_map[rhs_var]
        else:
            print(line)
            raise ValueError('aaah')

    assert lhs_var is not None
    assert rhs_w is not None


    rw_widths = {'pc': width_map[precond_var] if precond_var else None, 'lhs': width_map[lhs_var], 'rhs': rhs_w}
    return rw_widths, width_map, symbolic_vars, ssa_vars

# --- Settings ---
filename = sys.argv[1] if len(sys.argv) > 1 else "gen.cpp.inc"
base_output = "hydra_rules"


pattern = re.compile(r"/\*([\s\S]*?)\*/", re.DOTALL)

# Read file
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

comments = pattern.findall(content)

# Clean up existing output directories
if os.path.isdir(base_output):
    shutil.rmtree(base_output)


print(f"Found {len(comments)} comment blocks.")

# Initialize counters for each category
num_rw = 0

# Type: dict with 'mw' -> defaultdict of category lists, 'sw' -> list
mw_output: defaultdict[str, list[tuple[str, str, dict]]] = defaultdict(list)
sw_output: list[tuple[str, str, dict]] = []

for block in comments:
    block = block.strip()

    # Split at first empty line
    parts = block.split("\n\n", 1)

    top = parts[0].strip()
    bottom = parts[1].strip() if len(parts) > 1 else ""

    # Extract Opt number from first line
    first_line = top.splitlines()[0].strip()
    m = re.match(r"^Opt\s:\s*(\S+)", first_line)

    if not m:
        print("⚠ Warning: cannot find Opt number in block, skipping:")
        print(first_line)
        continue

    rewrite_ir = top.replace(first_line, '')

    res = extract_width_annotations(rewrite_ir)
    # print(res)
    rw_widths, bw_map, sym_vars, all_vars = res

    var_widths = [bw_map[var] for var in sym_vars]

    in_bw1 = all([w == '1' for w in var_widths])
    out_bw1 = all([w == '1' for w in [rw_widths['lhs'], rw_widths['rhs']]])

    opt_num = m.group(1)
    is_mw = any([cond in bottom for cond in ["zext", "sext", "trunc"]])

    res = re.search(r"(width\([^)]*\)\s+==\s+(\S+))", bottom)
    if res and res.group(2).isdigit():
        print(
            "Found width condition on multibw opt:", opt_num, ", cond: ", res.group(1)
        )
        is_mw = False

    # Parse the rewrite rule structure for .rw file
    rule_data: dict[str, str | None] = {"precondition": None, "lhs": None, "rhs": None}

    # Check if there's a guard/precondition (format: [guard] |= [rest])
    if "|=" in bottom:
        guard_parts = bottom.split("|=", 1)
        rule_data["precondition"] = guard_parts[0].strip()
        remaining = guard_parts[1].strip()
    else:
        remaining = bottom

    # Parse LHS and RHS (format: [lhs] => [rhs])
    if "=>" in remaining:
        arrow_parts = remaining.split("=>", 1)
        rule_data["lhs"] = arrow_parts[0].strip()
        rule_data["rhs"] = arrow_parts[1].strip()
    else:
        print("⚠ Warning: cannot find => in rewrite, skipping:", opt_num)
        continue

    num_rw += 1
    out_tuple = (opt_num, block, rule_data)
    if is_mw:
        match (in_bw1, out_bw1):
            case True, True:
                category = "inout1"
            case True, False:
                category = "in1"
            case False, True:
                category = "out1"
            case False, False:
                if "select" in bottom:
                    category = 'select'
                elif "sext" in bottom:
                    category = 'sext'
                else:
                    category = "default"
        mw_output[category].append(out_tuple)
    else:
        sw_output.append(out_tuple)

print(f"Found {num_rw} rewrites")

num_mw = sum([len(d) for d in mw_output.values()])
num_sw = len(sw_output)

print(f"{num_mw} multiwidth ones, {num_sw} single width")

for k, v in mw_output.items():
    print(f"{k}: {len(v)}")

# Create output directories and write files
print("\nWriting output files...")

# Create single-width directory and files
sw_dir = os.path.join(base_output, "single_width")
os.makedirs(sw_dir, exist_ok=True)

for opt_num, block_str, rule_data in sw_output:
    # Write .ir file with the block
    ir_file = os.path.join(sw_dir, f"opt_{opt_num}.ir")
    with open(ir_file, "w", encoding="utf-8") as f:
        f.write(block_str + "\n")

    # Write .rw file with the rule_data JSON
    rw_file = os.path.join(sw_dir, f"opt_{opt_num}.rw")
    with open(rw_file, "w", encoding="utf-8") as f:
        json.dump(rule_data, f, indent=2, ensure_ascii=False)
        f.write("\n")

print(f"Wrote {len(sw_output)} single-width rules to {sw_dir}")

# Create multi-width directories and files
mw_base_dir = os.path.join(base_output, "multi_width")

for category, rules in mw_output.items():
    category_dir = os.path.join(mw_base_dir, category)
    os.makedirs(category_dir, exist_ok=True)

    for opt_num, block_str, rule_data in rules:
        # Write .ir file with the block
        ir_file = os.path.join(category_dir, f"opt_{opt_num}.ir")
        with open(ir_file, "w", encoding="utf-8") as f:
            f.write(block_str + "\n")

        # Write .rw file with the rule_data JSON
        rw_file = os.path.join(category_dir, f"opt_{opt_num}.rw")
        with open(rw_file, "w", encoding="utf-8") as f:
            json.dump(rule_data, f, indent=2, ensure_ascii=False)
            f.write("\n")

    print(f"Wrote {len(rules)} multi-width '{category}' rules to {category_dir}")

