{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;

    # shell = "${pkgs.zsh}/bin/zsh";
    package = pkgs.tmux;

    keyMode = "vi";

    baseIndex = 1;
    mouse = true;
    historyLimit = 999999;
    escapeTime = 10;

    plugins = with pkgs.tmuxPlugins; [
      better-mouse-mode
      sensible
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];

    extraConfig = lib.concatStringsSep "\n" [
       # Shell configuration first
      "set-option -g default-shell ${pkgs.zsh}/bin/zsh"
      "set-option -g default-command ${pkgs.zsh}/bin/zsh"

      "set -g renumber-windows on"
      "bind r source-file ~/.tmux.conf \\; display \"Reloaded tmux config\""
      "set -g status-keys vi"
      "set -g default-terminal \"tmux-256color\""
      "set -ag terminal-overrides \",xterm-256color:RGB\""
      "bind | split-window -h"
      "bind - split-window -v"
      "bind J resize-pane -D 5"
      "bind K resize-pane -U 5"
      "bind L resize-pane -R 5"
      "bind H resize-pane -L 5"
      "bind -r h select-pane -L"
      "bind -r j select-pane -D"
      "bind -r k select-pane -U"
      "bind -r l select-pane -R"
      "bind -T copy-mode-vi v send -X begin-selection"
      "bind -T copy-mode-vi y send -X copy-selection"
    ];
  };
}

