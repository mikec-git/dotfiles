#!/bin/bash

# Dotfiles installation script
# Creates symlinks from home directory to dotfiles repo

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Files to symlink
FILES=(".zshrc" ".p10k.zsh" ".zprofile")

echo "Installing dotfiles..."

# Create backup directory if needed
backup_needed=false
for file in "${FILES[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        backup_needed=true
        break
    fi
done

if [ "$backup_needed" = true ]; then
    echo "Backing up existing files to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# Create symlinks
for file in "${FILES[@]}"; do
    target="$HOME/$file"
    source="$DOTFILES_DIR/$file"

    if [ -L "$target" ]; then
        echo "Removing existing symlink: $target"
        rm "$target"
    elif [ -f "$target" ]; then
        echo "Backing up: $target"
        mv "$target" "$BACKUP_DIR/"
    fi

    echo "Creating symlink: $target -> $source"
    ln -s "$source" "$target"
done

# Claude Code config
CLAUDE_DIR="$HOME/.claude"
CLAUDE_SOURCE="$DOTFILES_DIR/claude/CLAUDE.md"
CLAUDE_TARGET="$CLAUDE_DIR/CLAUDE.md"

if [ -f "$CLAUDE_SOURCE" ]; then
    mkdir -p "$CLAUDE_DIR"

    if [ -L "$CLAUDE_TARGET" ]; then
        echo "Removing existing symlink: $CLAUDE_TARGET"
        rm "$CLAUDE_TARGET"
    elif [ -f "$CLAUDE_TARGET" ]; then
        echo "Backing up: $CLAUDE_TARGET"
        mkdir -p "$BACKUP_DIR"
        mv "$CLAUDE_TARGET" "$BACKUP_DIR/"
    fi

    echo "Creating symlink: $CLAUDE_TARGET -> $CLAUDE_SOURCE"
    ln -s "$CLAUDE_SOURCE" "$CLAUDE_TARGET"
fi

echo ""
echo "Installation complete!"
echo "Run 'source ~/.zshrc' or restart your terminal to apply changes."
