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
  ];

  home.file = {
    "~/.config/starship.toml" = {
      source = ../../../starship/.config/starship.toml;
      target = "${config.home.homeDirectory}/.config/starship.toml";
    };

  };
}

