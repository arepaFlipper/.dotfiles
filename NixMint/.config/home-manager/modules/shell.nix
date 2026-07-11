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

      initExtra = ''
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
        name = "mint";
        colors = {
          arch_blue = "#5FA346";
          blue_mid = "#4A8636";
          blue_dark = "#356427";
          midnight_mid = "#20401A";
          midnight = "#12240E";
          text_light = "#F1F7EC";
          text_accent = "#B7E39A";
          russian_green = "#2E8B57";
          fluo_green = "#39FF88";
          color_red = "#FF5C5C";
          color_yellow = "#FFD166";
          yellow_dark = "#E0A800";
        };
      };
    };
  };
}

