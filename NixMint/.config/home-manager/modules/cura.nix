{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    cura
    curaengine_stable
  ];
}

