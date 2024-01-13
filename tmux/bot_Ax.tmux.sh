tmux kill-session -t bot_Ax; cd ~/Documents/ABEXUS/docker-wrapper; tmux has-session -t bot_Ax
 
 tmux new -s bot_Ax -n docker -d
 tmux setenv COMPOSE_FILE bot_Ax.yml
 tmux send-keys -t bot_Ax 'git checkout bot_Ax' C-m
 tmux send-keys -t bot_Ax 'export COMPOSE_FILE='bot_Ax.yml' && docker-compose up' C-m
 tmux split-window -v -t bot_Ax
 tmux split-window -h -t bot_Ax
 tmux split-pane -v -t bot_Ax:1.1
 tmux new-window -n boto_Ax -c "/home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax"
 cd /home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax; code .;
 tmux split-window -h -c "/home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax"
 tmux splitw -f -t bot_Ax -c "/home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax"

 tmux new-window -n TABLE -c "/home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax/P18_db/Table"
 tmux split-window -h -c "/home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax/P18_db/Table"
 tmux splitw -f -t bot_Ax -c "/home/tovar/Documents/ABEXUS/docker-wrapper/bot_Ax/P18_db/Table"

tmux attach -t bot_Ax