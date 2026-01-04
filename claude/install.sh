#!/bin/bash

# Claude Code configuration installation script
# Creates symlinks from ~/.claude to config files

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Claude config directory
CLAUDE_DIR="$HOME/.claude"
CLAUDE_FILES=("CLAUDE.md" "CLEAN_CODE.md")

echo "Installing Claude Code configuration..."

mkdir -p "$CLAUDE_DIR"

for file in "${CLAUDE_FILES[@]}"; do
    source="$SCRIPT_DIR/$file"
    target="$CLAUDE_DIR/$file"

    if [ -f "$source" ]; then
        if [ -L "$target" ]; then
            echo "Removing existing symlink: $target"
            rm "$target"
        elif [ -f "$target" ]; then
            echo "Backing up: $target"
            mkdir -p "$BACKUP_DIR"
            mv "$target" "$BACKUP_DIR/"
        fi

        echo "Creating symlink: $target -> $source"
        ln -s "$source" "$target"
    fi
done

echo "Claude Code configuration installed!"
