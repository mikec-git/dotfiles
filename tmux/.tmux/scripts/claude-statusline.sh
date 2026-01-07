#!/bin/bash
# Claude Code status line bridge for tmux
# Receives JSON from Claude Code and updates tmux pane labels

# Read JSON from stdin
input=$(cat)

# Check if we have jq available
if ! command -v jq &> /dev/null; then
    echo "Claude"
    exit 0
fi

# Extract relevant information
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // ""')
PROJECT_DIR=$(echo "$input" | jq -r '.workspace.project_dir // ""')
SESSION_ID=$(echo "$input" | jq -r '.session_id // ""')

# Use project dir if available, otherwise current dir
DIR="${PROJECT_DIR:-$CURRENT_DIR}"
DIR_NAME="${DIR##*/}"

# Get cost info if available
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0' 2>/dev/null)
if [[ "$COST" != "0" && "$COST" != "null" ]]; then
    COST_DISPLAY=$(printf "%.2f" "$COST")
else
    COST_DISPLAY=""
fi

# Create status file directory
STATUS_DIR="${XDG_RUNTIME_DIR:-/tmp}/claude-status"
mkdir -p "$STATUS_DIR"

# Get the current tmux pane ID if running in tmux
if [ -n "$TMUX_PANE" ]; then
    PANE_ID="${TMUX_PANE//[^0-9]/}"
    STATUS_FILE="$STATUS_DIR/pane-$PANE_ID"

    # Write status to file for tmux to read
    if [ -n "$COST_DISPLAY" ]; then
        echo "$MODEL | $DIR_NAME | \$$COST_DISPLAY" > "$STATUS_FILE"
    else
        echo "$MODEL | $DIR_NAME" > "$STATUS_FILE"
    fi
fi

# Output for Claude Code's built-in status line (with ANSI colors)
if [ -n "$COST_DISPLAY" ]; then
    printf "\033[36m%s\033[0m \033[90m|\033[0m \033[1m%s\033[0m \033[90m|\033[0m \033[33m\$%s\033[0m" "$MODEL" "$DIR_NAME" "$COST_DISPLAY"
else
    printf "\033[36m%s\033[0m \033[90m|\033[0m \033[1m%s\033[0m" "$MODEL" "$DIR_NAME"
fi
