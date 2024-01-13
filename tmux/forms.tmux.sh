#!/bin/sh
# -t: tag
# -n: name
# -d: dettach
session1="surv_logs"
window11="logs"
pane111=${window00}.1
window12="lazygit"
window13="neovim"
session2="surv_code"
window21="lazygit"
path="~/Documents/ABEXUS/wrap/surv"
# tmux kill-session -t $session0;
cd ~/Documents/ABEXUS/wrap/surv
# tmux new -s $session0;
 
tmux new -s $session1 -n $window11 -d;
tmux send-keys -t $window11 'docker-compose up -d && docker-compose logs -f' C-m
tmux split-window -v -t $window11 'cd ./frontend/client/ && npm run start'
tmux split-pane -h -t $window11.2
tmux split-pane -t $session1:1.1 'docker attach abacus_dj'

tmux new-window -n $window12 -c "$PWD"
tmux send-keys -t $window12 'lazygit' C-m

tmux new-window -n $window13 -c "$PWD"
tmux send-keys -t $window13 'nvim .' C-m

# session 2
tmux new -s $session2 -n $window21 -d
tmux send-keys -t $window21 'lazygit' C-m

tmux new-window -n $window13 -c "$PWD"
tmux send-keys -t $window13 'nvim .' C-m

tmux attach -t $session1:1
