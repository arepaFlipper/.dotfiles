{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  home.packages = with pkgs; [
    pkgs.zsh-autosuggestions
    python313Packages.pip
    pkgs.zsh-syntax-highlighting
    zoxide
    alacritty
    yt-dlp
    fzf
    (pkgs.nerdfonts.override { fonts = [ "Meslo" "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
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
        alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixOS/.config/home-manager"
        source $HOME/.dotfiles/zsh/.zshrc
      '';
    };

    bash = {
      enable = true;
      initExtra = ''
        [[ -f ~/.profile ]] && . ~/.profile
      '';
    };
  };
}

