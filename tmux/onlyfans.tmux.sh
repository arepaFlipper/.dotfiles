#!/bin/sh
# -t: target
# -n: name
# -d: detach

session1="logs"
session2="repo"
session3="code"
session4="notes"

obsidian="$HOME/sync_repo/brain/"
path="$HOME/Documents/yt-tutos/AsAProgrammer/onlyfans"

branch="main"

cd ${path}
# Ensure tmux sessions are killed if they already exist
tmux kill-session -t $session1 2>/dev/null
tmux kill-session -t $session2 2>/dev/null
tmux kill-session -t $session3 2>/dev/null
tmux kill-session -t $session4 2>/dev/null

# session 1: command line
tmux new-session -s $session1 -n "command line 💻" -d
tmux send-keys -t $session1:1 "cd ${path}/" C-m
tmux split-window -h -t $session1:1
tmux send-keys -t $session1:1.1 "npm run dev" C-m
tmux send-keys -t $session1:2.1 "cd ${path}/" C-m
tmux send-keys -t $session1:2.1 "npm run dev" C-m

# session 2: repo
tmux new-session -s $session2 -n "repo 🌲" -d
tmux send-keys -t $session2:1 "cd ${path}/ lazygit" C-m

# session 3: code
tmux new-session -s $session3 -n "code 👷" -d
tmux send-keys -t $session3:1 "cd ${path} && dvim ." C-m

# session 4: notes
tmux new-session -s $session4 -n "notes 📝" -d
tmux send-keys -t $session4:1 "cd ${obsidian}" C-m
tmux send-keys -t $session4:1 "bvim ./0-Inbox/1741387012-onlyfans-project.md" C-m

# Attach to the "code" session
tmux attach -t $session3
