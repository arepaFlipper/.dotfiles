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
alias abacus="~/abacus.tmux.sh"
alias p18="~/p18.tmux.sh"
alias bot="~/bot_Ax.tmux.sh"
alias 2nd_brain="~/2nd_brain.tmux.sh"
alias jupy="~/Documents/jupyter_notes/jupyter-init.sh"
alias dotfiles="~/dotfiles.tmux.sh"
alias recycle="~/recycle_chain.tmux.sh"
alias keyboard="~/qmk.tmux.sh"
alias litetech="~/litetech.tmux.sh"
alias onlyfans="~/onlyfans.tmux.sh"
alias debt="~/debt_collector.tmux.sh"
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
alias bvim="NVIM_APPNAME=bvim nvim"

extract-wisdom () {
  link=${1:""}
  "$HOME/scripts/extract_wisdom.sh" "$link";
}

line_up () {
  bash "$HOME/scripts/lineup.sh";
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

# bindkey -s ^; "nvims\n"

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
	direnv
)

if [[ "$OSTYPE" == darwin* ]]; then
  source $ZSH/oh-my-zsh.sh
  eval "$(rbenv init -)"
  eval "$(direnv hook zsh)"
  source ~/.p10k.M2.zsh
fi

if [[ "$OSTYPE" == linux* ]]; then
  OS_ID=$(grep -E '^ID=' /etc/os-release | awk -F'=' '{print tolower($2)}' | tr -d '"')

  if [[ "$OS_ID" == "nixos" ]]; then
    echo "Running on NixOS"
	source ~/.p10k.zsh
  elif [[ "$OS_ID" == "arch" ]]; then
    echo "Running on Arch"
    source ~/.p10k.arch.zsh
  else
    source $ZSH/oh-my-zsh.sh
    echo "Running on ($OS_ID)"
  fi
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  #source $ZSH/oh-my-zsh.sh

fi

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


# set vim as default IDE
export EDITOR=nvim
source ~/powerlevel10k/powerlevel10k.zsh-theme

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias vimdiff="NVIM_APPNAME=LazyVim nvim -d"


# bun completions
[ -s "/Users/christopher/.bun/_bun" ] && source "/Users/christopher/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export XCURSOR_THEME="catppuccin-mocha-sky-cursors"

export VAULT="$HOME/sync_repo/brain/"

eval "$(zoxide init --cmd cd zsh)"
if [ -f "$HOME/.config/fabric/fabric-bootstrap.inc" ]; then . "$HOME/.config/fabric/fabric-bootstrap.inc"; fi

# macOS-specific configurations



# Created by `pipx` on 2024-07-07 07:55:46
export PATH="$PATH:/Users/christopher/.local/bin"
if [ -f "/Users/christopher/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/christopher/.config/fabric/fabric-bootstrap.inc"; fi
