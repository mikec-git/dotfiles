#!/bin/bash

# Tmux configuration installation script
# Creates symlinks from home directory to tmux config files

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Files to symlink
FILES=(".tmux.conf")

echo "Installing tmux configuration..."

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
    source="$SCRIPT_DIR/$file"

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

echo "Tmux configuration installed!"
