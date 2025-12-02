import re
import os, shutil
import sys
import json


# --- Settings ---
filename = sys.argv[1] if len(sys.argv) > 1 else "gen.cpp.inc"
mw_output = "hydra_rules_mw"
other_output = "hydra_rules_normal"
# ---------------

pattern = re.compile(r'/\*([\s\S]*?)\*/', re.DOTALL)

# Read file
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

comments = pattern.findall(content)

shutil.rmtree(mw_output)
shutil.rmtree(other_output)

os.makedirs(mw_output, exist_ok=True)
os.makedirs(other_output, exist_ok=True)

print(f"Found {len(comments)} comment blocks.")

num_rw, num_mw = (0,0)

for block in comments:
    block = block.strip()

    # Split at first empty line
    parts = block.split("\n\n", 1)
    
    top = parts[0].strip()
    bottom = parts[1].strip() if len(parts) > 1 else ""

    # Extract Opt number from first line
    first_line = top.splitlines()[0].strip()
    m = re.match(r'^Opt\s:\s*(\S+)', first_line)
    
    if not m:
        print("⚠ Warning: cannot find Opt number in block, skipping:")
        print(first_line)
        continue

    opt_num = m.group(1)
    is_mw = any([cond in bottom for cond in ["zext", "sext", "trunc"]])
    
    res = re.search(r'(width\([^)]*\)\s+==\s+(\S+))', bottom)
    if res and res.group(2).isdigit():
        print("Found width condition on multibw opt:",opt_num, ", cond: ", res.group(1))
        is_mw = False
        
    
    if is_mw:
        num_mw += 1
    output_dir = mw_output if is_mw else other_output

    # Output filenames (both in same directory)
    ir_file = os.path.join(output_dir, f"opt_{opt_num}.ir")
    rw_file = os.path.join(output_dir, f"opt_{opt_num}.rw")

    # Write entire original block to .ir file
    with open(ir_file, "w", encoding="utf-8") as f:
        f.write(block + "\n")

    # Parse the rewrite rule structure for .rw file
    rule_data: dict[str, str | None] = {
        "precondition": None,
        "lhs": None,
        "rhs": None
    }

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

print(f"Found {num_rw} rewrites, {num_mw} multi width ones")