from collections import defaultdict
import re
import os
import shutil
import sys
import json
from dataclasses import dataclass
from typing import Union


@dataclass
class Constant:
    value: int
    width: int


@dataclass
class Op:
    op: str
    children: list[Union["Op", Constant, str]]  # str for variable references
    width: int


@dataclass
class Variable:
    name: str
    width: int


def parse_width(type_str: str) -> int:
    """Parse width from type string like 'i8' or 'i32'."""
    if type_str.startswith("i"):
        return int(type_str[1:])
    raise ValueError(f"Unknown type: {type_str}")


def parse_operand(operand: str, definitions: dict) -> Union[Op, Constant, str]:
    """Parse an operand which can be a reference, constant, or variable."""
    operand = operand.strip()
    
    # Check for constant like "0:i8" or "1:i1"
    if ":" in operand and not operand.startswith("%"):
        value_part, type_part = operand.split(":")
        return Constant(value=int(value_part), width=parse_width(type_part))
    
    # Check for reference like "%symconst_2" or "%v0"
    if operand.startswith("%"):
        ref_name = operand[1:].split(":")[0]  # Remove % and any type annotation
        if ref_name in definitions:
            return definitions[ref_name]
        return ref_name  # Return as string reference if not yet defined
    
    # Try to parse as plain integer (shouldn't happen often)
    try:
        return Constant(value=int(operand), width=0)
    except ValueError:
        return operand


def parse_souper(text: str) -> dict:
    """
    Parse Souper IR text and return a dictionary with the AST.
    Returns dict with 'infer' and 'result' keys containing the respective expressions.
    """
    definitions: dict[str, Union[Op, Constant, Variable]] = {}
    result = {"infer": None, "result": None, "pc": []}
    
    for line in text.strip().split("\n"):
        line = line.strip()
        if not line:
            continue
        
        # Remove comments
        if ";" in line:
            line = line.split(";")[0].strip()
        
        # Remove (hasExternalUses) annotations
        if "(hasExternalUses)" in line:
            line = line.replace("(hasExternalUses)", "").strip()
        
        if not line:
            continue
        print(line)
        
        # Handle 'infer %name'
        if line.startswith("infer "):
            ref = line[6:].strip()
            if ref.startswith("%"):
                ref_name = ref[1:]
                assert ref_name in definitions
                result["infer"] = definitions[ref_name]
            else:
                raise ValueError("shouldn't be here")
        
        # Handle 'result %name'
        elif line.startswith("result "):
            ref = line[7:].strip()
            if ref.startswith("%"):
                ref_name = ref[1:]
                assert ref_name in definitions
                result["result"] = definitions[ref_name]
            else:
                # results is a constant
                result["result"] = parse_operand(ref, definitions)

        # Handle 'pc %name value'
        elif line.startswith("pc "):
            parts = line[3:].strip().split()
            if len(parts) >= 2:
                cond = parse_operand(parts[0], definitions)
                val = parse_operand(parts[1], definitions)
                result["pc"].append({"condition": cond, "value": val})
            else:
                raise ValueError("shouldn't be here")
        # Handle assignments: %name:type = op args...
        elif "=" in line:
            left, right = line.split("=", 1)
            left = left.strip()
            right = right.strip()
            
            # Parse the left side: %name:type
            if left.startswith("%"):
                left = left[1:]  # Remove %
            name, type_str = left.split(":")
            width = parse_width(type_str)
            
            # Parse the right side
            parts = right.split()
            op_name = parts[0]
            
            if op_name == "var":
                # Variable declaration
                definitions[name] = Variable(name=name, width=width)
            else:
                # Operation with arguments
                args = parts[1:]
                children = []
                for arg in args:
                    # Handle comma-separated args (shouldn't happen in Souper but just in case)
                    arg = arg.rstrip(",")
                    children.append(parse_operand(arg, definitions))
                
                definitions[name] = Op(op=op_name, children=children, width=width)
        else:
            print(line)
            raise ValueError("reached the end of the function?")
            
    
    return result

def ast_to_dict(node: Union[Op, Constant, Variable, str, None]) -> Union[dict, None]:
    """Convert AST nodes to plain dictionaries for easier inspection."""
    if node is None:
        return None
    if isinstance(node, str):
        return {"ref": node}
    if isinstance(node, Constant):
        return {"type": "constant", "value": node.value, "width": node.width}
    if isinstance(node, Variable):
        return {"type": "variable", "name": node.name, "width": node.width}
    if isinstance(node, Op):
        return {
            "type": "op",
            "op": node.op,
            "width": node.width,
            "children": [ast_to_dict(c) for c in node.children],
        }
    return None


def parse_souper_to_dict(text: str) -> dict:
    """Parse Souper IR and return plain dictionaries."""
    result = parse_souper(text)
    return {
        "infer": ast_to_dict(result["infer"]),
        "result": ast_to_dict(result["result"]),
        "pc": [
            {"condition": ast_to_dict(pc["condition"]), "value": ast_to_dict(pc["value"])}
            for pc in result["pc"]
        ],
    }


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
    opt_num = m.group(1)

    rewrite_ir = top.replace(first_line, '')

    # try:
    parsed = parse_souper(rewrite_ir)
    print(parsed['result'])
    # except ValueError:
    #     print(f"{opt_num} failed: {block}")
    #     continue

    res = extract_width_annotations(rewrite_ir)
    # print(res)
    rw_widths, bw_map, sym_vars, all_vars = res

    var_widths = [bw_map[var] for var in sym_vars]

    in_bw1 = all([w == '1' for w in var_widths])
    out_bw1 = all([w == '1' for w in [rw_widths['lhs'], rw_widths['rhs']]])

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

