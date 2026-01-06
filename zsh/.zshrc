# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k theme (load early, not in turbo mode)
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Load zsh-completions synchronously (must be before compinit)
zinit light zsh-users/zsh-completions

# Initialize completion system
autoload -Uz compinit
compinit

# Plugins (turbo mode - loads after prompt for faster startup)
zinit wait lucid depth=1 for \
  atload"ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'" \
    zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting

# fzf-tab (must load after compinit, before other plugins that wrap widgets)
zinit light Aloxaf/fzf-tab

# fzf shell integration
eval "$(fzf --zsh)"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Custom tab: show files on empty prompt, otherwise normal completion
function complete-files-or-expand() {
  if [[ -z "$BUFFER" ]]; then
    BUFFER="./"
    CURSOR=2
  fi
  zle fzf-tab-complete
}
zle -N complete-files-or-expand
bindkey "^I" complete-files-or-expand

# macOS-style delete behavior (Cmd+Delete sends ^U)
bindkey "^U" backward-kill-line

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# zoxide (smarter cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi
# Git aliases
alias g='git'
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph'
alias gb='git branch'
alias gm='git merge'
alias grb='git rebase'

# Aliases
alias python='python3'
alias reload='source ~/.zshrc'

# Claude Code sandbox
alias sandbox='docker exec -it $(docker ps -qf "name=claude-sandbox") zsh'
alias cc='claude'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
