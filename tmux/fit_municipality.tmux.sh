#!/bin/sh

set -e

# This script sets up Tmux sessions, windows, and panes for a development environment.

# -t: tag
# -n: name
# -d: dettach

# Session name and window names
session_name="fit_municipality"
session1="${session_name}_logs"
window11="logs"
panel11=${window11}.1
window12="lazygit"

session2="${session_name}_code"
window21="neovim"
session3="${session_name}_repo"
window31="lazygit"
session4="${session_name}_DB"
window41="Postgres"
session5="${session_name}_ai"
window51="tool"
path="$HOME/Documents/${session_name}/feature-new-ui"

# Array to store successfully created/managed sessions
created_sessions=()

# Check if the path exists
if [ ! -d "$path" ]; then
    echo "Error: Working directory '$path' not found. Please create it or update the 'path' variable in the script."
    exit 1
fi

# Navigate to the working directory
cd "${path}/"

# Function to create or manage a tmux session
create_or_manage_session() {
    local session_name="$1"
    local description="$2"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Tmux session '$session_name' ($description) already exists."
        read -p "Do you want to (k)ill and recreate, or (s)kip? [k/s]: " choice
        case "$choice" in
            k|K)
                echo "Killing existing session '$session_name' and recreating it."
                tmux kill-session -t "$session_name"
                return 0 # Proceed to create session
                ;;
            s|S)
                echo "Skipping session '$session_name'."
                return 1 # Do not proceed with creating/configuring
                ;;
            *)
                echo "Invalid choice. Skipping session '$session_name'."
                return 1 # Do not proceed with creating/configuring
                ;;
        esac
    fi
    return 0 # Proceed to create session (session didn't exist)
}

# Session 1: Docker, Node.js, and Testing Environment
if create_or_manage_session "$session1" "Docker, Node.js, and Testing"; then
    tmux new -s "$session1" -n "$window11" -d
    tmux send-keys -t "$window11" 'docker-compose up -d && docker-compose logs -f' C-m
    tmux split-window -v -t "$window11" 'cd ./frontend/client/ && npm run start'
    tmux split-pane -h -t "$window11".2 'cd ./frontend/pollster/ && npm run start'
    tmux split-pane -v -t "$window11".1 'docker attach abacus_dj'
    tmux split-pane -h -t "$window11".1 'cd ./tests/ && npm run test'
    created_sessions+=("$session1")
fi

# Session 2: Code Editing
if create_or_manage_session "$session2" "Code Editing"; then
    tmux new -s "$session2" -n "$window21" -d
    tmux send-keys -t "$session2":1 'bvim .' C-m
    created_sessions+=("$session2")
fi

# Session 3 repository: LazyGit
if create_or_manage_session "$session3" "LazyGit Repository"; then
    tmux new -s "$session3" -n "$window31" -d
    tmux send-keys -t "$session3":1 'lazygit' C-m
    created_sessions+=("$session3")
fi

# Session 4 DB visualizer
if create_or_manage_session "$session4" "DB Visualizer"; then
    tmux new -s "$session4" -n "$window41" -d
    tmux send-keys -t "$session4":1 "nix develop --command zsh -c 'NVIM_APPNAME=bvim nvim +DBUI +only'" C-m
    created_sessions+=("$session4")
fi

# Session 5 AI: tool
if create_or_manage_session "$session5" "AI tool"; then
    tmux new -s "$session5" -n "$window41" -d
    tmux send-keys -t "$session5":1 'echo "AI hype sucks"' C-m
    created_sessions+=("$session5")
fi

# Final attachment logic
if [[ " ${created_sessions[*]} " =~ " ${session2} " ]]; then
    echo "Attaching to preferred session: $session2"
    tmux attach -t "$session2"
elif [ ${#created_sessions[@]} -gt 0 ]; then
    echo "Session $session2 not available. Attaching to first available session: ${created_sessions[0]}"
    tmux attach -t "${created_sessions[0]}"
else
    echo "No sessions were created or available to attach to."
fi

