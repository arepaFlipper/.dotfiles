#!/bin/sh
# -t: tag
# -n: name
# -d: dettach
session1="tuto_logs"

# folder_name="Josh_tried_coding/breadit"
# folder_name="js_mastery/pricewise"
# folder_name="EdRoh/portfolio"
# folder_name="Elliott-Chong/quizmify"

folder_name="2-Areas/academic/docker/"
window11="lazygit"
window12="lazygit"
window13="neovim"
path="$HOME/iPad_sync/obsidian_vault/${folder_name}/"
# tmux kill-session -t $session0;
cd ${path}
# tmux new -s $session0;

branch="main"
window11="lazygit"
pane111=${window00}.1
window12="lazygit"
window13="neovim"
session2="tuto_repo"
window21="lazygit"
session3="tuto_code"
window31="neovim"
session4="tuto_notes"
window41="obsidian"

# tmux kill-session -t $session0;
cd ${path}
# tmux new -s $session0;

# session 1
tmux new -s $session1 -n $window11 -d
# tmux send-keys -t $window11 'npm run dev' C-m
tmux split-pane -t $window11.1

# session 2
tmux new -s $session2 -n $window21 -d
tmux send-keys -t $window21 'lazygit' C-m

# session 3
tmux new -s $session3 -n $window31 -d
tmux send-keys -t $window31 'dvim .' C-m

# session 4
tmux new -s $session4 -n $window41 -d
tmux send-keys -t $session4 'cd ~/Documents/obsidian_vault/' C-m
tmux send-keys -t $session4 'dvim .' C-m

tmux attach -t $session3:1
