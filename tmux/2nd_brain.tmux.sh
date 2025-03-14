#!/bin/sh
session1="brain"

window11="lazygit"
window12="neovim"
path="$VAULT"
# tmux kill-session -t $session0;
cd ${path}
# tmux new -s $session0;

# session 1
tmux new -s $session1 -n $window11 -d
tmux send-keys -t $window11 'lazygit' C-m

tmux new-window -n $window12
tmux send-keys -t $window12 'bvim .' C-m

tmux split-window -v -t $window11 '/usr/bin/obsidian'

#
tmux attach -t $session1:2
