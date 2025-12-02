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
mw_output = "hydra_rules_multi_width"
other_output = "hydra_rules_single_width"
select_mw_out = mw_output + "/select"
in_1_out_1 = mw_output + "/in_out_1"
in_1_out_mw = mw_output + "/in_1"
in_mw_out_1 = mw_output + "/out_1"
default_mw_out = mw_output + "/default"
# ---------------

pattern = re.compile(r"/\*([\s\S]*?)\*/", re.DOTALL)

# Read file
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

comments = pattern.findall(content)

for d in [mw_output, other_output]:
    if os.path.isdir(d):
        shutil.rmtree(d)

for d in [other_output, select_mw_out, default_mw_out, in_1_out_1, in_1_out_mw, in_mw_out_1]:
    os.makedirs(d)

print(f"Found {len(comments)} comment blocks.")

num_rw, num_mw, num_mw_select, in1, out1, in_out_1 = (0, 0, 0, 0, 0, 0)

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

    if is_mw:
        # print(opt_num)
        # print(in_bw1, out_bw1)
        # print(var_widths)
        # print(rw_widths)
        # print(sym_vars)
        num_mw += 1
        if "select" in bottom:
            num_mw_select += 1
            output_dir = select_mw_out
        else:
            match (in_bw1, out_bw1):
                case True, True : 
                    output_dir = in_1_out_1
                    in_out_1 += 1
                case True, False : 
                    output_dir = in_1_out_mw
                    in1 +=1
                case False, True : 
                    output_dir = in_mw_out_1
                    out1 +=1
                case False, False :
                    output_dir = default_mw_out

    else:
        output_dir = other_output


    # Output filenames (both in same directory)
    ir_file = os.path.join(output_dir, f"opt_{opt_num}.ir")
    rw_file = os.path.join(output_dir, f"opt_{opt_num}.rw")

    # Write entire original block to .ir file
    with open(ir_file, "w", encoding="utf-8") as f:
        f.write(block + "\n")

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
    # Write parsed rule to .rw file as JSON
    with open(rw_file, "w", encoding="utf-8") as f:
        json.dump(rule_data, f, indent=2, ensure_ascii=False)
        f.write("\n")

print(
    f"Found {num_rw} rewrites, {num_mw} multi width ones.\n{num_mw - num_mw_select} multi width without select (ite), {num_mw_select} with"
)
print(f"{in1} with 1-bit input variables, {out1} with a 1-bit output, {in_out_1} with 1-bit in 1-bit out, {num_mw-num_mw_select-in1-out1-in_out_1} interesting cases?")
