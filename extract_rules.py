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

@dataclass
class PConst:
    value: int
    width: str

@dataclass
class PVar:
    name: str
    width: str
@dataclass
class POp:
    # parametric operation
    op: str
    children: list[Union["POp", PConst, PVar]]  # str for variable references
    width: str # parametric width




type GenericAst = Union[Op, Constant]


def parse_width(type_str: str) -> int:
    """Parse width from type string like 'i8' or 'i32'."""
    if type_str.startswith("i"):
        return int(type_str[1:])
    raise ValueError(f"Unknown type: {type_str}")


def parse_operand(operand: str, definitions: dict[str, Op | Variable]) -> Op | Variable | Constant:
    """Parse an operand which can be a reference, constant, or variable."""
    operand = operand.strip()
    
    # Check for constant like "0:i8" or "1:i1"
    if ":" in operand and not operand.startswith("%"):
        value_part, type_part = operand.split(":")
        return Constant(value=int(value_part), width=parse_width(type_part))
    
    # Check for reference like "%symconst_2" or "%v0"
    if operand.startswith("%"):
        ref_name = operand[1:].split(":")[0]  # Remove % and any type annotation
        assert ref_name in definitions
        return definitions[ref_name]
    else:
        raise ValueError('Should neve get here')


def parse_souper(text: str) -> dict[str, GenericAst]:
    """
    Parse Souper IR text and return a dictionary with the AST.
    Returns dict with 'infer' and 'result' keys containing the respective expressions.
    """
    definitions: dict[str, Union[Op, Variable]] = {}
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
                # result is a constant
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

def make_fresh_width(existing_widths: list[str]) -> str:
    if len(existing_widths) > 0:
        candidate = existing_widths[-1][0]
    else:
        existing_widths.append('p')
        return existing_widths[-1]
    while candidate in existing_widths:
        if candidate[-1] == 'z':
            candidate += 'a'
        candidate = chr((ord(candidate) + 1 - 97) % 26 + 97)
    existing_widths.append(candidate)
    return candidate

# Convert a generic AST capturing the souper/llvm semantics into a bwlang AST
def souper_to_bwlang(node: GenericAst, definitions: dict[str, PVar], width_conditions: list[Op], widths: list[str] ) -> POp | PConst | PVar:
    # Essentially inside of this function the specific bitwidths still presnet inside of the souper ir
    # need to be parametrised, and some conditions needs to be introduced to ensure the definition
    # is still sound, for ex. %a:iP = zext 3:iQ implies that Q < P
    # print(node)
    match node:
        case Op(op, childs, _width):
            # print(op)
            new_op = None
            w_out = None
            childs_p = [souper_to_bwlang(c, definitions, width_conditions, widths) for c in childs]
            BINOP_MAPPING = {
                'add': '+',
                'sub': '-',
                'mul': '*',
                'and': 'and',
                'xor': 'xor',
                'or': 'or',
                'shl': '<<',
                'shr': '>>',
            }
            match op:
                case op if op in BINOP_MAPPING:
                    # print('hello')
                    new_op = BINOP_MAPPING[op]
                    assert len(childs_p) == 2
                    w_out = childs_p[0].width
                    if (w_1 := childs_p[1].width) != w_out:
                        # abuse the Op class
                        width_conditions.append(Op("=", [w_out, w_1], 0))
                    assert new_op is not None
                    assert w_out is not None
                    return POp(new_op, childs_p, w_out)
                case 'trunc':
                    # a:i? = trunc %some_other_var
                    # the outgoing width must be smaller
                    assert len(childs_p) == 1
                    new_w = make_fresh_width(widths)
                    width_conditions.append(Op(">", [childs_p[0].width, new_w], 0))
                    return POp('bw', childs_p, new_w)
                case 'zext':
                    # %new_var:i(w_1) = zext %some_other_var
                    # outgoing will have a new fresh width, strictly larger than the original
                    assert len(childs_p) == 1
                    new_w = make_fresh_width(widths)
                    width_conditions.append(Op("<", [childs_p[0].width, new_w], 0))
                    return POp('bw', childs_p, new_w)
                case 'width':
                    # extracting the width of a variable/expression
                    # make it into a separate variable of width of the width
                    assert len(childs_p) == 1
                    return PVar(childs_p[0].width, childs_p[0].width)
                case _:
                    raise ValueError(f"Uknown op: {op}")
        case Variable(name, _width):
            if name not in definitions:
                # fresh width variable
                new_w = make_fresh_width(widths)
                new_var = PVar(name, new_w)
                definitions[name] = new_var
                return new_var
            else:
                return definitions[name]
        case Constant(value, _width):
            new_width = make_fresh_width(widths)
            return PConst(value, new_width)
        case _:
            print(node)
            raise ValueError("Shouldn't reach here")

def bwlang_to_string(node: POp | PConst | PVar | Op ) -> str:
    match node:
        case POp(op, childs, width):
            childs_str = [bwlang_to_string(c) for c in childs]
            if op == 'bw':
                assert len(childs_str) == 1
                return f"(bw {width} {childs_str[0]})"
            else:
                return f"(bw {width} ({op} {' '.join(childs_str)}))"
        case PVar(name, width):
            return f"(bw {width} {name})"
        case PConst(value, width):
            return f"(bw {width} {value})"
        case Op(op, childs, _width):
            # meta operation on the widths
            return f"({op} {' '.join([c for c in childs])})"
        case _:
            print(node)
            raise ValueError("String conversion never should reach here")

def update_p_widths(node: POp | PConst | PVar | Op, old_w : str, new_w : str) -> POp | PConst | PVar | Op:
    match node:
        case POp(op, childs, width):
            out_width = new_w if width == old_w else width
            return POp(op, [update_p_widths(c, old_w, new_w) for c in childs], out_width)
        case PConst(value, width):
            out_width = new_w if width == old_w else width
            return PConst(value, out_width)
        case PVar(name, width):
            out_width = new_w if width == old_w else width
            return PVar(name, out_width)
        case Op(op, childs, _width):
            # this is the special case for an operation (abused to represent the inferred conditions on the widths)
            # Assuming that the childs are string representing widths
            return Op(op, [new_w if c == old_w else c for c in childs], _width)

def rewrite_ir_to_bwlang(souper_ir: str) -> tuple[list[POp | PConst | PVar | Op] | None, POp | PConst | PVar, POp | PConst | PVar]:
    parsed_souper = parse_souper(souper_ir)
    
    widths = []
    width_conditions: list[Op] = []
    var_defs = {}
    precondition = None
    if len(pc:=parsed_souper['pc']) > 0:
        precondition = souper_to_bwlang(pc[0]['condition'], var_defs, width_conditions, widths)
    
    lhs = souper_to_bwlang(parsed_souper['infer'], var_defs, width_conditions, widths)
    rhs = souper_to_bwlang(parsed_souper['result'], var_defs, width_conditions, widths)

    width_conditions.append(Op('=', [lhs.width, rhs.width], -1))

    # print("generated width conds:", width_conditions)

    new_conditions: list[Op | POp | PConst | PVar] = []
    
    while len(width_conditions) > 0:
        cond = width_conditions.pop()
        match cond.op:
            case '=':
                assert len(cond.children) == 2 
                old_width, new_width = cond.children
                width_conditions = [update_p_widths(wc, old_width, new_width) for wc in width_conditions]
                new_conditions = [update_p_widths(wc, old_width, new_width) for wc in new_conditions]
                lhs = update_p_widths(lhs, old_width, new_width)
                rhs = update_p_widths(rhs, old_width, new_width)
                precondition = update_p_widths(precondition, old_width, new_width) if precondition else None
            case '>' | '<':
                new_conditions.append(cond)
            case _:
                raise ValueError(f"Condition unkown: {cond.op}")

    if precondition:
        new_conditions.append(precondition)

    return new_conditions, lhs, rhs

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
    rule_data: dict[str, str | None] = {"lhs": None, "rhs": None}

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

                    try:
                        cond, lhs, rhs = rewrite_ir_to_bwlang(rewrite_ir)
                        print(f"Succesfull converted {opt_num} to bwlang")
                        cond_str = None
                        # if cond:
                        #     cond_str = bwlang_to_string(cond)
                            # print(cond_str)
                            # print("  |=")
                        lhs_str = bwlang_to_string(lhs)
                        rhs_str = bwlang_to_string(rhs)
                        # print(lhs_str)
                        # print("  =>")
                        # print(rhs_str)
                        rule_data["preconditions"] = [*set([bwlang_to_string(c) for c in cond])] if cond else []
                        rule_data["lhs"] = lhs_str
                        rule_data["rhs"] = rhs_str
                        rule_data["name"] = f"hydra_opt_{opt_num}"
                    except ValueError as e:
                        print("Failed to translate:", opt_num, e)
                        mw_output["default"].append((opt_num, block, {}))
                        continue
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
        if category == 'default':
            rw_file = os.path.join(category_dir, f"opt_{opt_num}.bwlang")
        else:
            rw_file = os.path.join(category_dir, f"opt_{opt_num}.rw")
        
        if rule_data != {}:
            with open(rw_file, "w", encoding="utf-8") as f:
                json.dump(rule_data, f, indent=2, ensure_ascii=False)
                f.write("\n")

    print(f"Wrote {len([r for r in rules if r[2] != {}])} multi-width '{category}' rules to {category_dir}")

