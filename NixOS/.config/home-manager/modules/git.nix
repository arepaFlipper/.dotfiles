{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    delta
    lazygit
  ];
  programs.lazygit = {
  	enable = true;
  };
}

