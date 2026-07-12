{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    i3status
    i3lock
    dmenu
    rofi
    picom
    feh
    # pulseSupport defaults to false upstream, which is why config.ini's
    # pulseaudio module was silently disabled.
    (polybar.override { pulseSupport = true; }) # alternative status bar
    networkmanagerapplet # for network control in i3
    xdotool
    lxappearance
  ];

  # config.ini (shared across machines) does `include-file = colors.ini`;
  # this picks which palette that resolves to on this machine. See
  # i3/.config/polybar/colors-everforest.ini's header for the pattern.
  home.file."polybar-colors" = {
    source = "${config.home.homeDirectory}/.dotfiles/i3/.config/polybar/colors-everforest.ini";
    target = "${config.home.homeDirectory}/.config/polybar/colors.ini";
  };
}

