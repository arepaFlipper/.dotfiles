#!/usr/bin/env bash
set -e

# ── defaults (overridable per project block) ───────────────────────────────────
session_type="standard"
session_name=""
path=""
logs_cmd='echo "Set your logs"'
code_cmd='bvim .'
repo_cmd='lazygit'
db_cmd="nix develop --command zsh -c 'NVIM_APPNAME=bvim nvim +DBUI +only'"
ai_cmd='claude'

# Override this function in a project block for custom pane layouts
setup_logs_session() {
  tmux send-keys -t "$1":1 "$logs_cmd" C-m
}

# ── project configs ────────────────────────────────────────────────────────────
# To add a project: add a case block with at minimum `session_name` and `path`.
# Override `setup_logs_session` for custom log/dev-server pane layouts.

load_project() {
  case "$1" in
  abacus)
    session_name="abacus"
    path="$HOME/Documents/abacus/feature-new-ui"
    setup_logs_session() {
      local s="$1"
      tmux send-keys -t "$s":1 'docker-compose up -d && docker-compose logs -f' C-m
      tmux split-window -v -t "$s":1
      tmux send-keys -t "$s":1.{last} 'cd ./frontend/client/ && npm run start' C-m
      tmux split-window -h -t "$s":1.{last}
      tmux send-keys -t "$s":1.{last} 'cd ./frontend/pollster/ && npm run start' C-m
      tmux split-window -h -t "$s":1.{top-left}
      tmux send-keys -t "$s":1.{last} 'docker attach abacus_dj' C-m
      tmux split-window -h -t "$s":1.{last}
      tmux send-keys -t "$s":1.{last} 'cd ./tests/ && npm run test' C-m
    }
    ;;
  intranet)
    session_name="intranet"
    path="$HOME/Documents/ABEXUS/infranet/dev"
    setup_logs_session() {
      local s="$1"
      tmux send-keys -t "$s":1 'docker compose up -d && docker compose logs -f' C-m
      tmux split-window -v -t "$s":1
      tmux split-window -h -t "$s":1.{last}
      tmux send-keys -t "$s":1.{last} 'nix develop --command zsh -c "source .env && cloud-sql-proxy abexus-intranet:us-central1:intranet-db --port 5433"' C-m
    }
    ;;
  2nd_brain)
    session_type="brain"
    session_name="brain"
    path="${VAULT:-$HOME/sync_repo/brain}"
    ;;
  dotfiles)
    session_type="dotfiles"
    session_name="dotfiles"
    path="$HOME/.dotfiles"
    ;;
  forms)
    session_name="forms"
    path="$HOME/Documents/ABEXUS/wrap/surv"
    ;;
  tuto)
    session_name="tuto"
    path="$HOME/sync_repo/obsidian_vault/2-Areas/academic/docker"
    ;;
  ecommerce)
    session_name="ecommerce"
    path="$HOME/Documents/yt-tutos/WebDevSimplified/ecommerce"
    ;;
  iomobile)
    session_name="iomobile"
    path="$HOME/Documents/yt-tutos/ionic_react_capacitor"
    ;;
  quiz_craft)
    session_name="quiz_craft"
    path="$HOME/Documents/yt-tutos/Elliott-Chong/quizmify"
    ;;
  rust_tuto)
    session_name="rust_tuto"
    path="$HOME/sync_repo/obsidian_vault/2-Areas/academic/rust"
    ;;
  chatapp)
    session_name="chatapp"
    path="$HOME/Documents/yt-tutos/Desphixs/chat_app"
    ;;
  microservices)
    session_name="microservices"
    path="$HOME/Documents/yt-tutos/freeCodeCamp/micro"
    ;;
  portfolio)
    session_name="portfolio"
    path="$HOME/Documents/yt-tutos/EdRoh/portfolio"
    ;;
  docker_tuto)
    session_name="docker_tuto"
    path="$HOME/sync_repo/obsidian_vault/2-Areas/academic/docker"
    ;;
  git_tuto)
    session_name="git_tuto"
    path="$HOME/sync_repo/obsidian_vault/2-Areas/academic/GIT"
    ;;
  leetcode)
    session_name="leetcode"
    path="$HOME/Documents/yt-tutos/neetcode/leetcoding"
    ;;
  bot)
    session_name="bot_Ax"
    path="$HOME/Documents/ABEXUS/docker-wrapper"
    ;;
  recycle)
    session_name="recycle"
    path="$HOME/Documents/yt-tutos/recycle-blockchain-tracker"
    ;;
  keyboard)
    session_name="keyboard"
    path="$HOME/qmk_setup"
    ;;
  litetech)
    session_name="litetech"
    path="$HOME/Documents/litebox"
    ;;
  onlyfans)
    session_name="onlyfans"
    path="$HOME/Documents/yt-tutos/AsAProgrammer/onlyfans"
    ;;
  debt)
    session_name="debt_collector"
    path="$HOME/Documents/debt_collector"
    ;;
  fit)
    session_name="fit_municipality"
    path="$HOME/Documents/fit_municipality/feature-new-ui"
    ;;
  pop)
    session_name="pop"
    path="$HOME/torrentflix"
    ;;
  *)
    return 1
    ;;
  esac
}

# ── helpers ────────────────────────────────────────────────────────────────────

list_projects() {
  grep -E '^\s+[a-zA-Z0-9_-]+\)$' "$0" | tr -d ' )' | sort
}

create_or_manage() {
  local name="$1" desc="$2"
  if tmux has-session -t "$name" 2>/dev/null; then
    printf "Session '%s' (%s) exists — (k)ill / (s)kip / (a)ttach [s]: " "$name" "$desc"
    read -r choice
    case "$choice" in
    k | K) tmux kill-session -t "$name" ;;
    a | A)
      tmux attach -t "$name"
      exit 0
      ;;
    *) return 1 ;;
    esac
  fi
}

# ── templates ─────────────────────────────────────────────────────────────────

launch_standard() {
  local name="$1"
  local -a created

  local s1="${name}_logs" s2="${name}_code" s3="${name}_repo" s4="${name}_DB" s5="${name}_ai"

  if create_or_manage "$s1" "logs"; then
    tmux new -s "$s1" -n "logs" -d
    setup_logs_session "$s1"
    created+=("$s1")
  fi
  if create_or_manage "$s2" "code"; then
    tmux new -s "$s2" -n "neovim" -d
    tmux send-keys -t "$s2":1 "$code_cmd" C-m
    created+=("$s2")
  fi
  if create_or_manage "$s3" "repo"; then
    tmux new -s "$s3" -n "lazygit" -d
    tmux send-keys -t "$s3":1 "$repo_cmd" C-m
    created+=("$s3")
  fi
  if create_or_manage "$s4" "database"; then
    tmux new -s "$s4" -n "Postgres" -d
    tmux send-keys -t "$s4":1 "$db_cmd" C-m
    created+=("$s4")
  fi
  if create_or_manage "$s5" "AI"; then
    tmux new -s "$s5" -n "tool" -d
    tmux send-keys -t "$s5":1 "$ai_cmd" C-m
    created+=("$s5")
  fi

  if [[ " ${created[*]} " =~ " ${s2} " ]]; then
    tmux attach -t "$s2"
  elif [[ ${#created[@]} -gt 0 ]]; then
    tmux attach -t "${created[0]}"
  else
    echo "No new sessions created."
  fi
}

launch_brain() {
  local sname="${session_name:-brain}"
  if create_or_manage "$sname" "brain"; then
    tmux new -s "$sname" -n "lazygit" -d
    tmux send-keys -t "$sname":1 'lazygit' C-m
    tmux new-window -t "$sname" -n "neovim"
    tmux send-keys -t "$sname":2 'bvim .' C-m
    tmux split-window -v -t "$sname":1 '/usr/bin/obsidian'
    tmux attach -t "$sname":2
  fi
}

launch_dotfiles() {
  local name="${session_name:-dotfiles}"
  local -a created

  local s1="${name}_code" s2="${name}_repo" s3="${name}_ai" s4="${name}_terminal"

  if create_or_manage "$s1" "code"; then
    tmux new -s "$s1" -n "neovim" -d
    tmux send-keys -t "$s1":1 "$code_cmd" C-m
    created+=("$s1")
  fi
  if create_or_manage "$s2" "repo"; then
    tmux new -s "$s2" -n "lazygit" -d
    tmux send-keys -t "$s2":1 "$repo_cmd" C-m
    created+=("$s2")
  fi
  if create_or_manage "$s3" "AI"; then
    tmux new -s "$s3" -n "tool" -d
    tmux send-keys -t "$s3":1 "$ai_cmd" C-m
    created+=("$s3")
  fi
  if create_or_manage "$s4" "terminal"; then
    tmux new -s "$s4" -n "terminal" -d
    created+=("$s4")
  fi

  if [[ " ${created[*]} " =~ " ${s1} " ]]; then
    tmux attach -t "$s1"
  elif [[ ${#created[@]} -gt 0 ]]; then
    tmux attach -t "${created[0]}"
  else
    echo "No new sessions created."
  fi
}

# ── interactive setup ──────────────────────────────────────────────────────────

interactive_setup() {
  echo "tmoxpen — interactive"
  echo ""
  read -rp "Project name: " session_name
  [[ -n "$session_name" ]] || {
    echo "Error: name required."
    exit 1
  }

  read -rp "Project path [$PWD]: " path
  path="${path:-$PWD}"
  path="${path/#\~/$HOME}"
  [[ -d "$path" ]] || {
    echo "Error: '$path' does not exist."
    exit 1
  }

  echo ""
  echo "Template:"
  echo "  1) standard — 5 sessions: logs, code, repo, DB, ai  (default)"
  echo "  2) brain    — 1 session:  lazygit + neovim + obsidian"
  read -rp "Choice [1]: " t
  [[ "${t:-1}" == "2" ]] && session_type="brain" || session_type="standard"

  cd "$path"
  case "$session_type" in
  brain) launch_brain ;;
  dotfiles) launch_dotfiles ;;
  standard) launch_standard "$session_name" ;;
  esac
}

# ── dispatch ───────────────────────────────────────────────────────────────────

if [[ $# -eq 0 ]]; then
  interactive_setup
  exit 0
fi

project="$1"

if ! load_project "$project"; then
  echo "Unknown project '${project}'."
  echo ""
  echo "Known projects:"
  list_projects | sed 's/^/  /'
  echo ""
  echo "Run without arguments to set up interactively."
  exit 1
fi

[[ -n "$path" ]] || {
  echo "Config for '${project}' must set \$path."
  exit 1
}
[[ -d "$path" ]] || {
  echo "Error: path '$path' not found for '${project}'."
  exit 1
}

cd "$path"
case "$session_type" in
brain) launch_brain ;;
dotfiles) launch_dotfiles ;;
standard) launch_standard "${session_name:-$project}" ;;
esac
