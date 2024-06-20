# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.cargo/bin:$HOME/.config/git/git-log-compact:/usr/local/bin:/usr/bin:$PATH


#Aliases
alias ns="npm run start"
alias nb="npm run build"
alias ndv="npm run dev"
alias gcof="git checkout -f"
alias drs="source ./.env/bin/activate && ./manage.py runserver 0.0.0.0:8000"
alias fig="docker-compose"
alias bashtouch="yes 'touch $0' | chmod +x $0"
alias econ="~/econ.tmux.sh"
alias forms="~/forms.tmux.sh"
alias tuto="~/tuto.tmux.sh"
alias ecommerce="~/ecommerce.tmux.sh"
alias iomobile="~/ionic.tmux.sh"
alias quiz_craft="~/quiz_craft_ai.tmux.sh"
alias ta="tmux attach"
alias rust_tuto="~/rust_tuto.tmux.sh"
alias chatapp="~/chatapp_tuto.tmux.sh"
alias microservices="~/microservices.tmux.sh"
alias portfolio="~/portfolio.tmux.sh"
alias docker_tuto="~/docker_tuto.tmux.sh"
alias git_tuto="~/git_tuto.tmux.sh"
alias leetcode="~/leetcode.tmux.sh"
alias ttask="~/taskwarrior.tmux.sh"
alias abacus="~/abacus.tmux.sh"
alias p18="~/p18.tmux.sh"
alias bot="~/bot_Ax.tmux.sh"
alias 2nd_brain="~/2nd_brain.tmux.sh"
alias jupy="~/Documents/jupyter_notes/jupyter-init.sh"
alias dotfiles="~/dotfiles.tmux.sh"
alias keyboard="~/qmk.tmux.sh"
alias V="/usr/bin/nvim"
alias rk="~/.cargo/bin/rust-kanban"

alias lvim="NVIM_APPNAME=LazyVim nvim"
alias dvim="NVIM_APPNAME=devaslife nvim"
alias kvim="NVIM_APPNAME=kickstart nvim"
alias chvim="NVIM_APPNAME=NvChad nvim"
alias avim="NVIM_APPNAME=AstroNvim nvim"
alias texvim="NVIM_APPNAME=benbrastmckie nvim"
alias vimtex="NVIM_APPNAME=VimTeX nvim"
alias leetvim="NVIM_APPNAME=leetvim nvim"

extract-wisdom () {
  link=${1:""}
  "$HOME/scripts/extract_wisdom.sh" "$link";
}


alias tn="task add $1"
alias td="task delete $1"
alias twl="task list"

alias routine_tasks="bash ~/.dotfiles/taskwarrior/.task/routine.sh"
alias meditation_tasks="bash ~/.dotfiles/taskwarrior/.task/meditations.sh"
task_project_function () {
  task $1 modify project:$2
}

alias tproj="task_project_function"

task_tag_function () {
  task $1 modify +$2 +$3 +$4
}

alias ttag="task_tag_function"

newcakefunction () {
    task add Bake cake for $1 due:$2 scheduled:due-4d wait:due-5d project:$3
    task add buy eggs +$1,grocery due:$2 scheduled:due-1d wait:-2d project:$3
    task add buy flour +$1,grocery due:$2 scheduled:due-1d wait:-2d project:$3
    task add buy milk +$1,grocery due:$2 scheduled:due-1d wait:-2d project:$3
}

alias newcake=newcakefunction

function nvims(){
  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim" "packervim" "tuffgniuz" "benbrastmckie" "VimTeX" "ejmastnak" "leetvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config >>" --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0 
  elif [[ $config == "default" ]]; then
    config=""
  fi 
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^ñ "nvims\n"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
# DELETEME: 

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
	tmux
	git
)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Open tmux on startup, requires tmux plugin
ZSH_TMUX_AUTOSTART=true

source ~/.dotfiles/zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# set vim as default IDE
export EDITOR=nvim
source ~/powerlevel10k/powerlevel10k.zsh-theme

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export OPENAI_API_KEY="$(gpg --decrypt $HOME/.gpt_key.gpg 2>&1| tail -n 1)"

alias vimdiff="NVIM_APPNAME=LazyVim nvim -d"


# bun completions
[ -s "/Users/cristianf.tovar/.bun/_bun" ] && source "/Users/cristianf.tovar/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## Taskwarrior
export TASKDDATA="/var/taskd"
export VAULT="$HOME/iPad_sync/obsidian_vault/"

eval "$(zoxide init --cmd cd zsh)"
if [ -f "/home/tovar/.config/fabric/fabric-bootstrap.inc" ]; then . "/home/tovar/.config/fabric/fabric-bootstrap.inc"; fi
