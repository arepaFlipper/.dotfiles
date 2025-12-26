{ config, pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; };};
  imports = [ <home-manager/nix-darwin> ];
in
{
  home.homeDirectory = "/Users/christopher";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    starship
  ];

  imports = [
    ./modules/shell.nix
    ./modules/tmux.nix
    ./modules/document_viewer.nix
  ];

  home.file = {
    "~/.config/starship.toml" = {
      source = ../../../starship/.config/starship.toml;
      target = "${config.home.homeDirectory}/.config/starship.toml";
    };

    "~/.tmux.conf" = {
      source = ../../../tmux/.tmux.conf;
      target = "${config.home.homeDirectory}/.tmux.conf";
    };

    "~/.tmux.conf.local" = {
      source = ../../../tmux/.tmux.conf.local;
      target = "${config.home.homeDirectory}/.tmux.conf.local";
    };

  };
}

