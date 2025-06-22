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
    #alacritty
    yt-dlp
    fzf
    oh-my-zsh
    #(pkgs.nerdfonts.override { fonts = [ "Meslo" "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
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


  };
}

