#!/bin/bash

# Dotfiles installation script
# Runs all component install scripts

set -e

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing dotfiles..."
echo ""

# Install zsh configuration
"$DOTFILES_DIR/zsh/install.sh"
echo ""

# Install Claude Code configuration
"$DOTFILES_DIR/claude/install.sh"
echo ""

echo "All configurations installed!"
