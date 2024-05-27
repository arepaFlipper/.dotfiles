#!/bin/sh
# -t: tag
# -n: name
# -d: dettach
session1="tuto_logs"

# folder_name="Josh_tried_coding/breadit"
# folder_name="js_mastery/pricewise"
# folder_name="EdRoh/portfolio"
# folder_name="Elliott-Chong/quizmify"

folder_name="2-Areas/academic/microservices/"
window11="lazygit"
window12="lazygit"
window13="neovim"
path="/home/tovar/Documents/yt-tutos/freeCodeCamp/micro"
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

# session 1 (logs)
tmux new -s $session1 -n $window11 -d
tmux send-keys -t $window11 'minikube tunnel --bind-address rabbitmq-manager.com' C-m
tmux split-pane -t $window11.1
tmux split-pane -t -h $window11.2

# session 2 (git)
tmux new -s $session2 -n $window21 -d
tmux send-keys -t $window21 'lazygit' C-m
tmux new-window -t $session2 -n "k9s" 'k9s'

# session 3 (code)
tmux new -s $session3 -n $window31 -d
tmux send-keys -t $window31 'dvim .' C-m

# session 4 (notes)
tmux new -s $session4 -n $window41 -d
tmux send-keys -t $session4 'cd /iPad_sync/obsidian_vault/ && dvim .' C-m

tmux attach -t $session3:1
