#!/bin/bash
# Display cheatsheet as a popup overlay on the right side

tmux display-popup -E -x R -w 30 -h 95% "$HOME/.tmux/scripts/cheatsheet.sh"
