#!/bin/sh

set -e

SESSION=dotfiles

if tmux has-session -t $SESSION 2> /dev/null; then
  tmux attach -t $SESSION
  exit
fi

tmux new-session -d -s $SESSION -n Shell
tmux new-window -t $SESSION -n Source

# 2. 
tmux attach-session -t $SESSION
