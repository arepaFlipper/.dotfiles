{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
in 
{
  home = {

    packages = with pkgs; [
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting
        pkgs.zoxide
        yt-dlp
        fzf
        python313Packages.pip
    ];
  };
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
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

