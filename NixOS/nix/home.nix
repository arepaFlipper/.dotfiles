{ config, pkgs, ... }:
{
  imports = [
    ./sh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "cris";
  home.homeDirectory = "/home/cris";

  # This value determines the Home Manager release that your configuration is compatible with.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your environment.

  home.packages = with pkgs; [ 
    zsh-powerlevel10k 
    meslo-lgs-nf 
  ];
  programs.zsh.enable = true;
  #home.file.".p10k.zsh".text = builtins.readFile /home/cris/.dotifiles/NixOS/nix/p10k.zsh;


  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    # Example configuration for dotfiles
  };

  # Home Manager can also manage your environment variables through 'home.sessionVariables'.
  home.sessionVariables = {
    EDITOR = "vim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}

