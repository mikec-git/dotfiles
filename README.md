# Dotfiles

Configuration files for ZSH, Claude Code, and Superwhisper.

<img width="807" height="146" alt="image" src="https://github.com/user-attachments/assets/fdd1f41e-a56d-411e-855a-0629df4cb6fa" />
<br><br>
<img width="358" height="127" alt="image" src="https://github.com/user-attachments/assets/847e4e91-3c30-461b-92fe-5927149c797c" />
<br><br>
<img width="275" height="307" alt="image" src="https://github.com/user-attachments/assets/2499214e-d3df-4e21-b7ad-4650a50eb3b6" />
<br><br>

## Contents

### zsh/
ZSH and Powerlevel10k configuration:
- `.zshrc` - ZSH configuration with Zinit plugin manager
- `.p10k.zsh` - Powerlevel10k theme configuration
- `.zprofile` - Shell login profile (PATH settings)

### claude/
[Claude Code](https://github.com/anthropics/claude-code) configuration:
- `CLAUDE.md` - Global instructions for Claude Code
- `CLEAN_CODE.md` - Code style guidelines

### superwhisper/
[Superwhisper](https://superwhisper.com/) voice-to-text settings:
- `settings.json` - Vocabulary, replacements, and preferences

## Prerequisites

**ZSH:**
- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager for ZSH
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - ZSH theme
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command
- [Nerd Font](https://www.nerdfonts.com/) - For icons in prompt

**Superwhisper:**
- [jq](https://jqlang.github.io/jq/) - For settings merge (`brew install jq`)

## Installation

```bash
git clone https://github.com/mchoi/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The main install script runs the ZSH and Claude installers. Each component can also be installed individually:

```bash
# ZSH only
./zsh/install.sh

# Claude Code only
./claude/install.sh

# Superwhisper only (interactive merge)
./superwhisper/install.sh
```

All installers:
1. Back up existing config files to `~/.dotfiles-backup/`
2. Create symlinks to the repo files

The Superwhisper installer includes an interactive merge when existing settings are found.

## After Installation

Restart your terminal or run:
```bash
source ~/.zshrc
```



