{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;

    # Basic behavior
    baseIndex = 1;              # window index starts at 1
    # Many options are exposed by Home Manager: mouse, prefix, historyLimit, etc.
    mouse = true;
    historyLimit = 999999;
    escapeTime = 10;

    # Use this shell inside tmux (optional)
    # shell = "${pkgs.zsh}/bin/zsh";

    # Plugins: you can list tmuxPlugins or custom plugin entries
    plugins = with pkgs.tmuxPlugins; [
      # built-in ones, e.g.
      better-mouse-mode
      sensible
      # You can also specify an object with plugin + extraConfig, e.g.
      {
        plugin = resurrect;
        extraConfig = ''
          # configure resurrect plugin, if installed
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];

    # Additional tmux config appended verbatim into ~/.tmux.conf
    extraConfig = lib.concatStringsSep "\n"
      ([
        # reorder windows after deleting one
        "set -g renumber-windows on"

        # vi mode in copy mode (for example)
        "setw -g mode-keys vi"

        # reload tmux config keybinding
        "bind r source-file ~/.tmux.conf \\; display \"Reloaded tmux config\""

        # status line or other preferences
        "set -g status-keys vi"
        "set -g default-terminal \"tmux-256color\""
        "set -ag terminal-overrides \",xterm-256color:RGB\""

        # pane splitting shortcuts
        "bind | split-window -h"
        "bind - split-window -v"
        "bind J resize-pane -D 5"
        "bind K resize-pane -U 5"
        "bind L resize-pane -R 5"
        "bind H resize-pane -L 5"

        "bind -r h select-pane -L"  # move left
        "bind -r j select-pane -D"  # move down
        "bind -r k select-pane -U"  # move up
        "bind -r l select-pane -R"  # move right

        # copy mode v / y bindings in vi style
        "bind -T copy-mode-vi v send -X begin-selection"
        "bind -T copy-mode-vi y send -X copy-selection"
      ]);

  };
}

