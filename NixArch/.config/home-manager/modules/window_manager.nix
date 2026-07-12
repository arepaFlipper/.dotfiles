{ config, pkgs, unstable-pkgs, ... }:

{
  # polybar from the pinned stable nixpkgs has a broken closure on this
  # machine (glibc/alsa-lib version skew, same class of bug as ghostty
  # and qutebrowser): it fails to even start with
  # "GLIBC_ABI_GNU2_TLS not found". unstable-pkgs' build doesn't have
  # this problem. pulseSupport defaults to false upstream, which is why
  # config.ini's pulseaudio module was silently disabled.
  home.packages = with pkgs; [
    i3status
    i3lock
    dmenu
    rofi
    picom
    feh
    (unstable-pkgs.polybar.override { pulseSupport = true; }) # alternative status bar
    networkmanagerapplet # for network control in i3
    xdotool
  ];

  # config.ini (shared across machines) does `include-file = colors.ini`;
  # this picks which palette that resolves to on this machine. See
  # i3/.config/polybar/colors-gruvbox.ini's header for the pattern.
  home.file."polybar-colors" = {
    source = "${config.home.homeDirectory}/.dotfiles/i3/.config/polybar/colors-gruvbox.ini";
    target = "${config.home.homeDirectory}/.config/polybar/colors.ini";
  };
}

