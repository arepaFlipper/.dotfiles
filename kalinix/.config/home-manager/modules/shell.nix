{ config, pkgs, inputs, lib, ... }:

{
  # Programs
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initContent = lib.mkOrder 500 ''
      echo "Restored shell config 🐲"
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
    '';

    shellAliases = {
      la = "ls -lha";
      # put other aliases you remember
    };

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [ "git" "tmux" "autopep8" "pip" "python" "pyenv"];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = import ../../../../zsh/starship-settings.nix {
      name = "kali";
      colors = {
        arch_blue = "#B0272A";
        blue_mid = "#8C1F22";
        blue_dark = "#5C1416";
        midnight_mid = "#2B0A0B";
        midnight = "#150505";
        text_light = "#F5E6E6";
        text_accent = "#FF8A8A";
        russian_green = "#2E8B57";
        fluo_green = "#39FF88";
        color_red = "#FF3B3B";
        color_yellow = "#FFD166";
        yellow_dark = "#E0A800";
      };
    };
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

  # Add packages you want in your shell
  home.packages = with pkgs; [
    # example
    fzf
    fd
    lazygit
    starship
    unzip
  ];
}

