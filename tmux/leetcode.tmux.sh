#!/bin/sh
# -t: tag, -n: name, -d: dettach
session1="leetcode"
folder_name="neetcode/leetcoding"
window11=$session1
path="$HOME/Documents/yt-tutos/${folder_name}/"
tmux kill-session -t $session1;
cd ${path}

tmux new -s $session1 -n $window11 -d
tmux send-keys -t $window11 'leetvim leetcode.nvim' C-m
tmux attach -t $session1:1
