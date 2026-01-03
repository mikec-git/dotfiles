# Dotfiles

My ZSH and Powerlevel10k configuration files.

## Contents

- `.zshrc` - ZSH configuration with Zinit plugin manager
- `.p10k.zsh` - Powerlevel10k theme configuration
- `.zprofile` - Shell login profile (PATH settings)

## Prerequisites

- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager for ZSH
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - ZSH theme
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command
- [Nerd Font](https://www.nerdfonts.com/) - For icons in prompt

## Installation

```bash
git clone https://github.com/mchoi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:
1. Back up any existing config files to `~/.dotfiles-backup/`
2. Create symlinks from your home directory to this repo

## After Installation

Restart your terminal or run:
```bash
source ~/.zshrc
```
