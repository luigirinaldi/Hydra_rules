import re
import sys
import os

filename = sys.argv[1] if len(sys.argv) > 1 else "gen.cpp.inc"
output_dir = "comments"

# Regex for /* ... */ including newlines
pattern = re.compile(r'/\*([\s\S]*?)\*/', re.DOTALL)

# Read file
with open(filename, "r", encoding="utf-8") as f:
    content = f.read()

comments = pattern.findall(content)

# Ensure folder exists
os.makedirs(output_dir, exist_ok=True)

print(f"Found {len(comments)} comment blocks.")

for i, text in enumerate(comments):
    out_file = os.path.join(output_dir, f"comment_{i}.txt")
    with open(out_file, "w", encoding="utf-8") as f:
        f.write(text.strip() + "\n")
    print(f"Saved: {out_file}")

