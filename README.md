# Dotfiles

My ZSH and Powerlevel10k configuration files.
<img width="358" height="127" alt="image" src="https://github.com/user-attachments/assets/847e4e91-3c30-461b-92fe-5927149c797c" />

<img width="275" height="307" alt="image" src="https://github.com/user-attachments/assets/2499214e-d3df-4e21-b7ad-4650a50eb3b6" />

<img width="807" height="146" alt="image" src="https://github.com/user-attachments/assets/fdd1f41e-a56d-411e-855a-0629df4cb6fa" />

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

