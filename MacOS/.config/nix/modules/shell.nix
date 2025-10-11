{ config, pkgs, inputs, lib, ... }:
{

  home.packages = with pkgs; [
    fzf
    fd
    lazygit
    starship
    unzip
  ];

  # Programs
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initContent = lib.mkOrder 500 ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      export VAULT="$HOME/sync_repo/brain/";
    '';

    shellAliases = {
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
      recycle="~/recycle_chain.tmux.sh";
      keyboard="~/qmk.tmux.sh";
      litetech="~/litetech.tmux.sh";
      onlyfans="~/onlyfans.tmux.sh";
      debt="~/debt_collector.tmux.sh";
      fit="~/fit_municipality.tmux.sh";
      V="/usr/bin/nvim";
      rk="~/.cargo/bin/rust-kanban";
      lvim="NVIM_APPNAME=lazyvim nvim";
      dvim="NVIM_APPNAME=devaslife nvim";
      kvim="NVIM_APPNAME=kickstart nvim";
      chvim="NVIM_APPNAME=nvchad nvim";
      avim="NVIM_APPNAME=astronvim nvim";
      texvim="NVIM_APPNAME=benbrastmckie nvim";
      vimtex="NVIM_APPNAME=vimtex nvim";
      leetvim="NVIM_APPNAME=leetvim nvim";
      bvim="NVIM_APPNAME=bvim nvim";
      tmux="command tmux";
    };

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [ "git" "autopep8" "pip" "python" "pyenv"];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Minimum Configuration: Customizing the prompt
  };

  programs.bash = {
    enable = false;
    bashrcExtra = ''
      zsh
    '';
  };

  # Optionally include zoxide etc.
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

}
