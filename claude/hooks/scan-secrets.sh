#!/bin/bash
# Scan staged files for sensitive data patterns before commit
# Exit code 2 = block (sensitive data found)
# Exit code 0 = allow (clean)

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null)

if [ -z "$STAGED_FILES" ]; then
    exit 0
fi

# Patterns to detect sensitive data
PATTERNS=(
    # API Keys
    'sk-[a-zA-Z0-9]{20,}'
    'pk_live_[a-zA-Z0-9]+'
    'pk_test_[a-zA-Z0-9]+'
    'AKIA[0-9A-Z]{16}'

    # Generic API key assignments
    'api[_-]?key\s*[:=]\s*["\047][^"\047]{10,}["\047]'
    'apikey\s*[:=]\s*["\047][^"\047]{10,}["\047]'

    # AWS
    'aws_secret_access_key\s*[:=]'
    'aws_access_key_id\s*[:=]'

    # Private Keys
    'BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY'

    # Tokens
    '(auth_token|access_token|refresh_token|bearer_token)\s*[:=]\s*["\047]'

    # Generic secrets (password, secret, credential followed by assignment)
    '(password|passwd|pwd)\s*[:=]\s*["\047][^"\047]+["\047]'
    'secret\s*[:=]\s*["\047][^"\047]{8,}["\047]'
    'credential\s*[:=]\s*["\047][^"\047]+["\047]'

    # Database connection strings with passwords
    '(mysql|postgres|mongodb)://[^:]+:[^@]+@'
)

FOUND_SECRETS=0
FINDINGS=""

for file in $STAGED_FILES; do
    # Skip binary files and common non-code files
    if [[ "$file" =~ \.(png|jpg|jpeg|gif|ico|woff|woff2|ttf|eot|pdf)$ ]]; then
        continue
    fi

    # Skip if file doesn't exist (deleted file)
    if [ ! -f "$file" ]; then
        continue
    fi

    for pattern in "${PATTERNS[@]}"; do
        # Use git show to get staged content (not working directory)
        MATCHES=$(git show ":$file" 2>/dev/null | grep -inE "$pattern" 2>/dev/null)
        if [ -n "$MATCHES" ]; then
            FOUND_SECRETS=1
            FINDINGS="${FINDINGS}\n[!] $file:\n$MATCHES\n"
        fi
    done
done

if [ $FOUND_SECRETS -eq 1 ]; then
    echo "BLOCKED: Potential sensitive data detected in staged files:" >&2
    echo -e "$FINDINGS" >&2
    echo "" >&2
    echo "If this is a false positive, you can:" >&2
    echo "  1. Remove the sensitive data and re-stage" >&2
    echo "  2. Add to .gitignore if the file shouldn't be committed" >&2
    exit 2
fi

exit 0
