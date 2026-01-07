#!/bin/bash
# Get Claude Code status for a tmux pane
# Usage: get-pane-status.sh <pane_id>
# Returns Claude status if available, otherwise the pane's current command

PANE_ID="$1"
STATUS_DIR="${XDG_RUNTIME_DIR:-/tmp}/claude-status"

# Extract numeric part of pane ID for status file
PANE_NUM="${PANE_ID//[^0-9]/}"
STATUS_FILE="$STATUS_DIR/pane-$PANE_NUM"

if [ -f "$STATUS_FILE" ]; then
    # Check if file is recent (less than 60 seconds old)
    if [ "$(find "$STATUS_FILE" -mmin -1 2>/dev/null)" ]; then
        cat "$STATUS_FILE"
        exit 0
    fi
fi

# No valid Claude status, get pane's current command from tmux
if [ -n "$PANE_ID" ]; then
    tmux display-message -p -t "$PANE_ID" '#{pane_current_command}' 2>/dev/null
else
    echo "shell"
fi
