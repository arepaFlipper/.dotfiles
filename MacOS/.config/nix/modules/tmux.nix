{ config, pkgs, lib, ... }:

{
  # Same pattern as NixArch's modules/tmux.nix: keep programs.tmux minimal and
  # delegate all keybindings/theming to the shared gpakosz/oh-my-tmux framework
  # at ~/.dotfiles/tmux/.tmux.conf. The framework is themed by whichever file
  # TMUX_CONF_LOCAL points at; on alpha that's the dracula theme. Do NOT also
  # symlink ~/.tmux.conf (see home.nix) — with no ~/.tmux.conf present, tmux
  # reads the XDG config home-manager generates here, which sources the
  # framework and sets TMUX_CONF, so `prefix r`/`prefix e` keep working.
  programs.tmux = {
    enable = true;
    package = pkgs.tmux;
    mouse = true;
    keyMode = "vi";

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

    extraConfig = ''
      # The gpakosz/oh-my-tmux framework is self-referential: it re-reads
      # $TMUX_CONF to extract its own embedded shell helpers, e.g.
      #   run 'cut -c3- "$TMUX_CONF" | sh -s _apply_configuration'
      # It only auto-detects TMUX_CONF when unset, and its detection would
      # land on the home-manager-generated ~/.config/tmux/tmux.conf (this very
      # wrapper), which has no _apply_configuration function -> `sh` exits 127
      # and `prefix r`/`prefix e` break. So pin TMUX_CONF to the framework file
      # itself *before* sourcing it.
      set-environment -g TMUX_CONF "$HOME/.dotfiles/tmux/.tmux.conf"

      # dracula theme override: TMUX_CONF_LOCAL only defaults to the framework's
      # $TMUX_CONF.local if unset, so pointing it at our own file overrides just
      # the theme. Other machines set their own (e.g. gruvbox on NixArch).
      set-environment -g TMUX_CONF_LOCAL "$HOME/.dotfiles/tmux/dracula.tmux.conf.local"
      source $HOME/.dotfiles/tmux/.tmux.conf
    '';
  };
}
