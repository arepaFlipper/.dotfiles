#!/usr/bin/env bash

# reldir="$(dirname -- "$0")"
reldir="$HOME/.dotfiles/"
cd "$reldir"
directory="$(pwd)"

cd "${directory}"
tmux kill-session -t dotfiles
tmux has-session -t dotfiles

tmux new -s dotfiles -n nvim -d
tmux send-key -t nvim "bvim ." C-m

tmux attach -t dotfiles
