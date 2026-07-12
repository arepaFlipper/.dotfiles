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

  #home.file.".tmux.conf".source = ../../../../tmux/.tmux.conf;
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      # Gruvbox Dark theme: TMUX_CONF_LOCAL only gets set to the framework's
      # default ($TMUX_CONF.local) if it isn't already set, so pointing it at
      # our own file here overrides just the theme. Other machines use their
      # own theme file (e.g. dracula, everforest, catppuccin) the same way.
      set-environment -g TMUX_CONF_LOCAL "$HOME/.dotfiles/tmux/gruvbox.tmux.conf.local"
      source $HOME/.dotfiles/tmux/.tmux.conf
    '';

  };
}
