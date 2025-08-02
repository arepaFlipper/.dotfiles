{ config, lib, pkgs, ... }:

with lib;

let

  defaultKeyMode = "vim";
  defaultResize = 5;
  defaultShortcut = "b";
  defaultTerminal = "screen";
  defaultShell = "zsh";

  boolToStr = value: if value then "on" else "off";

  tmuxConf = ''
    source $HOME/.dotfiles/tmux/.tmux.conf
  '';


in {

  home.file.".tmux.conf".source = ../../../../tmux/.tmux.conf;
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      source $HOME/.dotfiles/tmux/.tmux.conf
    '';

  };
}
