{ config, pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; };};
  imports = [ <home-manager/nix-darwin> ];
in
{
  home.homeDirectory = "/Users/christopher";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    ./modules/shell.nix
  ];
}

