#!/usr/bin/env python3
"""
format-prettier.py - PostToolUse hook
Runs prettier on supported file types after Edit/Write operations.
"""
import json
import re
import subprocess
import sys

SUPPORTED_EXTENSIONS = r'\.(ts|tsx|js|jsx|json|yaml|yml|md|css|scss)$'

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"[hook] format-prettier: invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    file_path = input_data.get("tool_input", {}).get("file_path", "")

    if not file_path:
        sys.exit(0)

    if not re.search(SUPPORTED_EXTENSIONS, file_path):
        sys.exit(0)

    print(f"[hook] format-prettier: formatting {file_path}")

    try:
        subprocess.run(
            ["npx", "prettier", "--write", "--ignore-unknown", file_path],
            capture_output=True,
            timeout=25
        )
        print("[hook] format-prettier: done")
    except subprocess.TimeoutExpired:
        print("[hook] format-prettier: timeout", file=sys.stderr)
    except Exception as e:
        print(f"[hook] format-prettier: error: {e}", file=sys.stderr)

    sys.exit(0)

if __name__ == "__main__":
    main()
