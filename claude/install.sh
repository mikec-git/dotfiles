#!/bin/bash

# Claude Code configuration installation script
# Creates symlinks from ~/.claude to config files

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Claude config directory
CLAUDE_DIR="$HOME/.claude"
CLAUDE_FILES=("CLAUDE.md" "CLEAN_CODE.md" "settings.json")

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

# Symlink hooks directory
HOOKS_SOURCE="$SCRIPT_DIR/hooks"
HOOKS_TARGET="$CLAUDE_DIR/hooks"

if [ -d "$HOOKS_SOURCE" ]; then
    if [ -L "$HOOKS_TARGET" ]; then
        echo "Removing existing symlink: $HOOKS_TARGET"
        rm "$HOOKS_TARGET"
    elif [ -d "$HOOKS_TARGET" ]; then
        echo "Backing up: $HOOKS_TARGET"
        mkdir -p "$BACKUP_DIR"
        mv "$HOOKS_TARGET" "$BACKUP_DIR/"
    fi

    echo "Creating symlink: $HOOKS_TARGET -> $HOOKS_SOURCE"
    ln -s "$HOOKS_SOURCE" "$HOOKS_TARGET"
fi

echo "Claude Code configuration installed!"
