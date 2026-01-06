#!/usr/bin/env python3
"""
fix-eslint.py - PostToolUse hook
Runs eslint --fix on JS/TS files after Edit/Write operations.
"""
import json
import re
import subprocess
import sys

SUPPORTED_EXTENSIONS = r'\.(ts|tsx|js|jsx)$'

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"[hook] fix-eslint: invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)

    file_path = input_data.get("tool_input", {}).get("file_path", "")

    if not file_path:
        sys.exit(0)

    if not re.search(SUPPORTED_EXTENSIONS, file_path):
        sys.exit(0)

    print(f"[hook] fix-eslint: fixing {file_path}")

    try:
        subprocess.run(
            ["npx", "eslint", "--fix", "--no-warn-ignored", file_path],
            capture_output=True,
            timeout=25
        )
        print("[hook] fix-eslint: done")
    except subprocess.TimeoutExpired:
        print("[hook] fix-eslint: timeout", file=sys.stderr)
    except Exception as e:
        print(f"[hook] fix-eslint: error: {e}", file=sys.stderr)

    sys.exit(0)

if __name__ == "__main__":
    main()
