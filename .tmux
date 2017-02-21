#!/bin/sh

set -e

SESSION=dotfiles

if tmux has-session -t $SESSION 2> /dev/null; then
  tmux attach -t $SESSION
  exit
fi

tmux new-session -d -s $SESSION -n Home

# 1. Main window: NOTES, TODO, status
tmux send-keys -t $SESSION:Home "vim NOTES" Enter
tmux split-window -t $SESSION:Home -h
tmux send-keys -t $SESSION:Home.right "vim TODO" Enter
tmux split-window -t $SESSION:Home.2
tmux send-keys -t $SESSION:Home.bottom-right "./status.sh" Enter

# 2. 
tmux attach -t $SESSION:Home.left
