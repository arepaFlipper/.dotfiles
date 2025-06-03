{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
  home = {

    packages = with pkgs; [
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting
        pkgs.zoxide
        yt-dlp
        fzf
        (pkgs.nerdfonts.override { fonts = [ "Meslo" "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
    ];
  };
in 
{
  programs = {
    zsh = {
        enable = true;
        enableCompletion = true;

        autosuggestion.enable = true;
        syntaxHighlighting = {
            enable = true;
        };

        oh-my-zsh = {
          enable = true;
          plugins = [ 
            "git" 
            "sudo" 
            "tmux" 
            "pip" 
          ];
        };

          initExtra = ''
            alias hmsi="home-manager switch --impure"
            alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixOS/.config/home-manager"
            source $HOME/.dotfiles/zsh/.zshrc
            source $HOME/.dotfiles/NixOS/.p10k.zsh
          '';
    };
    bash = {
      enable = true;
        
      initExtra = ''
        # include .profile if it exists
        [[ -f ~/.profile ]] && . ~/.profile
      '';
    };
  };

}
