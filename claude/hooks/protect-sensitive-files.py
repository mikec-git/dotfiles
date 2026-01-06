#!/usr/bin/env python3
"""
protect-sensitive-files.py - PreToolUse hook
Blocks Edit/Write operations on sensitive files (.env, .git/, lock files, credentials).
Exit code 2 = block operation
Exit code 0 = allow operation
"""
import json
import re
import sys

BLOCKED_PATTERNS = r'(\.env|\.git/|lock\.yaml|package-lock\.json|credentials)'

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"[hook] protect-sensitive-files: invalid JSON input: {e}", file=sys.stderr)
        sys.exit(0)  # Allow on parse error to avoid blocking legitimate operations

    file_path = input_data.get("tool_input", {}).get("file_path", "")

    if not file_path:
        sys.exit(0)

    if re.search(BLOCKED_PATTERNS, file_path):
        print(f"[hook] protect-sensitive-files: BLOCKED - cannot edit sensitive file: {file_path}", file=sys.stderr)
        sys.exit(2)

    print(f"[hook] protect-sensitive-files: allowed {file_path}")
    sys.exit(0)

if __name__ == "__main__":
    main()
