#!/bin/sh

# This script sets up Tmux sessions, windows, and panes for a development environment.

# -t: tag
# -n: name
# -d: dettach

# Session name and window names
session_name="debt_collector"
session1="${session_name}_logs"
window11="logs"
pane111=${window00}.1
window12="lazygit"
session2="${session_name}_code"
window21="neovim"
session3="${session_name}_repo"
window31="lazygit"
session4="${session_name}_db"
window41="bvim ."
path="$HOME/Documents/${session_name}"

# Navigate to the working directory
cd "${path}/"

# Session 1: Docker, Node.js, and Testing Environment
tmux new -s $session1 -n $window11 -d
tmux send-keys -t $window11 'npm i' C-m
tmux split-window -v -t $window11 'npm run dev'

# Session 2: Code Editing
tmux new -s $session2 -n $window21 -d
tmux send-keys -t $session2:1 'bvim .' C-m

# Session 3 repository: LazyGit
tmux new -s $session3 -n $window31 -d
tmux send-keys -t $session3:1 'lazygit' C-m

# Session 4 repository: DadBod Database
# tmux new -s $session4 -d
# tmux send-keys -t $session4 'bvim .' C-m

# Attach to Session 2 to start development environment
tmux attach -t $session2
