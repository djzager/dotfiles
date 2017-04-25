#!/bin/sh

set -e

SESSION=dotfiles

if tmux has-session -t $SESSION 2> /dev/null; then
  tmux attach -t $SESSION
  exit
fi

DIR="$PWD/DevelopmentEnv/src/$SESSION"
tmux new-session -d -s $SESSION -n Shell
tmux new-window -t $NAME -c $DIR -n Source

# 2. 
tmux attach -t $SESSION:Home.left
