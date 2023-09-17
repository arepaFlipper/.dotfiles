#!/bin/sh
# -t: tag
# -n: name
# -d: dettach
session1="Taskwarrior"

folder_name="taskwarrior"
window11="lazygit"
window12="Interface"
window13="neovim"
path="$HOME/.dotfiles/${folder_name}"
# tmux kill-session -t $session0;
cd ${path}
# tmux new -s $session0;

# session 2
tmux new -s $session1 -n $window11 -d
tmux send-keys -t $window11 'lazygit' C-m
#
tmux new-window -n $window12
tmux send-keys -t $window12 'taskwarrior-tui' C-m

tmux new-window -n $window13
tmux send-keys -t $window13 'lvim .' C-m
#
tmux attach -t $session1:2
