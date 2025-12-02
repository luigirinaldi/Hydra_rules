import re
import os
import sys

# --- Settings ---
filename = sys.argv[1] if len(sys.argv) > 1 else "gen.cpp.inc"
comments_dir_ir = "hydra_ir"
comments_dir_rw = "rewrite"
# ---------------

pattern = re.compile(r'/\*([\s\S]*?)\*/', re.DOTALL)

# Read file
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

comments = pattern.findall(content)

os.makedirs(comments_dir_ir, exist_ok=True)
os.makedirs(comments_dir_rw, exist_ok=True)

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

    # Output filenames
    ir_file = os.path.join(comments_dir_ir, f"opt_{opt_num}.ir")
    rw_file = os.path.join(comments_dir_rw, f"opt_{opt_num}.rw")

    with open(ir_file, "w", encoding="utf-8") as f:
        f.write(top + "\n")

    with open(rw_file, "w", encoding="utf-8") as f:
        f.write(bottom + "\n")

    # print(f"Saved: {ir_file}")
    # print(f"Saved: {rw_file}")
