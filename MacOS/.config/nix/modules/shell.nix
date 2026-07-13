{ config, pkgs, inputs, lib, ... }:
{

  home.packages = with pkgs; [
    fzf
    fd
    lazygit
    starship
    unzip
    doppler
  ];

  # Programs
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    # Put Homebrew (/opt/homebrew/bin) back on PATH. nix-darwin's generated
    # /etc/zprofile doesn't run path_helper, and home-manager owns ~/.zprofile,
    # so brew shellenv has to be declared here to survive darwin-rebuild.
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initContent = lib.mkOrder 500 ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      export VAULT="$HOME/sync_repo/brain/";
      export EDITOR=vim;
      source $HOME/.dotfiles/zsh/.zshrc
    '';

    shellAliases = {
      la = "ls -lha";
      tmux="command tmux";
    };

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [ "git" "tmux" "autopep8" "pip" "python" "pyenv"];
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
