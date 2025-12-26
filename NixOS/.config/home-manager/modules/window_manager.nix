{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    i3status
    i3lock
    dmenu
    rofi
    picom
    feh
    polybar # alternative status bar
    networkmanagerapplet # for network control in i3
    xdotool
  ];

}

