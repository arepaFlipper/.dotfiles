{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
  home.packages = with pkgs; [
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.zoxide
  ];
  sessionVariables = {
    GOOGLE_API_KEY = "";
    YOUTUBE_API_KEY = "";
    OPENAI_API_KEY = "";
  };
  variables = sessionVariables;
  localVariables = variables;
  myAliases = {
    la = "ls -lha";
		ns="npm run start";
		nb="npm run build";
		ndv="npm run dev";
		gcof="git checkout -f";
		drs="source ./.env/bin/activate && ./manage.py runserver 0.0.0.0:8000";
		fig="docker-compose";
		bashtouch="yes 'touch $0' | chmod +x $0";
		econ="~/econ.tmux.sh";
		forms="~/forms.tmux.sh";
		tuto="~/tuto.tmux.sh";
		ecommerce="~/ecommerce.tmux.sh";
		iomobile="~/ionic.tmux.sh";
		quiz_craft="~/quiz_craft_ai.tmux.sh";
		ta="tmux attach";
		rust_tuto="~/rust_tuto.tmux.sh";
		pytest_tuto="~/pytest.tmux.sh";
		chatapp="~/chatapp_tuto.tmux.sh";
		microservices="~/microservices.tmux.sh";
		portfolio="~/portfolio.tmux.sh";
		docker_tuto="~/docker_tuto.tmux.sh";
		git_tuto="~/git_tuto.tmux.sh";
		leetcode="~/leetcode.tmux.sh";
		abacus="~/abacus.tmux.sh";
		p18="~/p18.tmux.sh";
		bot="~/bot_Ax.tmux.sh";
		"2nd_brain"="~/2nd_brain.tmux.sh";
		jupy="~/Documents/jupyter_notes/jupyter-init.sh";
		dotfiles="~/dotfiles.tmux.sh";
		keyboard="~/qmk.tmux.sh";
    inlaze="~/InlazeMovies.tmux.sh";
		fs_node="~/fs_node.tmux.sh";
    inventory_management="~/inventory-management.tmux.sh";

		lvim="NVIM_APPNAME=LazyVim nvim";
		dvim="NVIM_APPNAME=devaslife nvim";
		kvim="NVIM_APPNAME=kickstart nvim";
		chvim="NVIM_APPNAME=NvChad nvim";
		avim="NVIM_APPNAME=AstroNvim nvim";
		texvim="NVIM_APPNAME=benbrastmckie nvim";
		vimtex="NVIM_APPNAME=VimTeX nvim";
		leetvim="NVIM_APPNAME=leetvim nvim";
		tl="tmux ls";
    hmsi="home-manager switch --impure";
  };
in 
{
  programs.zsh = {
		enable = true;
		sessionVariables = sessionVariables;
    shellAliases = myAliases;
		enableCompletion = true;

		autosuggestion.enable = true;
		syntaxHighlighting = {
				enable = true;
		};

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" ];
    };

			initExtra = ''
				[[ ! -f ~/.dotfiles/zsh/.config/zsh/.p10k.zsh ]] || source ~/.dotfiles/zsh/.config/zsh/.p10k.zsh

        source $HOME/.dotfiles/zsh/.zshrc
        export PATH=$PATH:~/.local/share/pipx/venvs/fabric/bin
		    export VAULT="$HOME/sync_repo/brain";

			'';
  };

  programs.bash = {
    enable = true;
    
    initExtra = ''
      # include .profile if it exists
      [[ -f ~/.profile ]] && . ~/.profile
    '';
  };
}
