import re
import os
import sys
import json

# --- Settings ---
filename = sys.argv[1] if len(sys.argv) > 1 else "gen.cpp.inc"
output_dir = "hydra_rules"
# ---------------

pattern = re.compile(r'/\*([\s\S]*?)\*/', re.DOTALL)

# Read file
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

comments = pattern.findall(content)

os.makedirs(output_dir, exist_ok=True)

print(f"Found {len(comments)} comment blocks.")

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
        # If no arrow, store everything as LHS
        rule_data["lhs"] = remaining.strip()

    # Write parsed rule to .rw file as JSON
    with open(rw_file, "w", encoding="utf-8") as f:
        json.dump(rule_data, f, indent=2, ensure_ascii=False)
        f.write("\n")

    # print(f"Saved: {ir_file}")
    # print(f"Saved: {rw_file}")
