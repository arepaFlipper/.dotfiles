{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home.packages = with pkgs; [
    zsh-autosuggestions
    python313Packages.pip
    zsh-syntax-highlighting
    zoxide
    yt-dlp
    fzf
    oh-my-zsh
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "tmux" "pip" ];
      };

      initContent = ''
        alias hmsi="home-manager switch --impure"
        alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixArch/.config/home-manager"
        source $HOME/.dotfiles/zsh/.zshrc
        if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.nix-profile/bin/zsh" ]; then
            export SHELL="$HOME/.nix-profile/bin/zsh"
            exec "$HOME/.nix-profile/bin/zsh"
        fi
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = import ../../../../zsh/starship-settings.nix {
        name = "arch";
        colors = {
          arch_blue = "#1793d1";
          blue_mid = "#0074ae";
          blue_dark = "#394260";
          midnight_mid = "#212736";
          midnight = "#1d2230";
          text_light = "#e3e5e5";
          text_accent = "#769ff0";
          russian_green = "#68A063";
          fluo_green = "#17fc03";
          color_red = "#cc241d";
          color_yellow = "#d79921";
          yellow_dark = "#d5b60a";
        };
      };
    };
  };
}

