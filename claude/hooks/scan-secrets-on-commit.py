#!/usr/bin/env python3
"""
scan-secrets-on-commit.py - PreToolUse hook
Scans for secrets before git commit/add operations.
Calls scan-secrets.sh if the command is a git commit or git add.
"""
import json
import os
import re
import subprocess
import sys

GIT_COMMIT_ADD_PATTERN = r'^git (commit|add)'
SCAN_SCRIPT = os.path.expanduser("~/.claude/hooks/scan-secrets.sh")

def main():
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"[hook] scan-secrets-on-commit: invalid JSON input: {e}", file=sys.stderr)
        sys.exit(0)

    command = input_data.get("tool_input", {}).get("command", "")

    if not command:
        sys.exit(0)

    if not re.search(GIT_COMMIT_ADD_PATTERN, command):
        sys.exit(0)

    if not os.path.exists(SCAN_SCRIPT):
        print(f"[hook] scan-secrets-on-commit: scan script not found: {SCAN_SCRIPT}", file=sys.stderr)
        sys.exit(0)

    try:
        result = subprocess.run(
            [SCAN_SCRIPT],
            timeout=25
        )
        sys.exit(result.returncode)
    except subprocess.TimeoutExpired:
        print("[hook] scan-secrets-on-commit: timeout", file=sys.stderr)
        sys.exit(0)
    except Exception as e:
        print(f"[hook] scan-secrets-on-commit: error: {e}", file=sys.stderr)
        sys.exit(0)

if __name__ == "__main__":
    main()
