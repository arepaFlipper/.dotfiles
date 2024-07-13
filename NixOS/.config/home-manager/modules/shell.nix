{ config, pkgs, ... }:
let
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

		lvim="NVIM_APPNAME=LazyVim nvim";
		dvim="NVIM_APPNAME=devaslife nvim";
		kvim="NVIM_APPNAME=kickstart nvim";
		chvim="NVIM_APPNAME=NvChad nvim";
		avim="NVIM_APPNAME=AstroNvim nvim";
		texvim="NVIM_APPNAME=benbrastmckie nvim";
		vimtex="NVIM_APPNAME=VimTeX nvim";
		leetvim="NVIM_APPNAME=leetvim nvim";
  };
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
in 
{
  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
    initExtra = "source ~/.p10k.zsh";
    plugins = [
      {
        name = "powerlevel10k-config";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ]; 
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
	};

  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };
}
