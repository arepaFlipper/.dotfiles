{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.tmux;

  pluginName = p: if types.package.check p then p.pname else p.plugin.pname;

  pluginModule = types.submodule {
    options = {
      plugin = mkOption {
        type = types.package;
        description = "Path of the configuration file to include.";
      };

      extraConfig = mkOption {
        type = types.lines;
        description = "Additional configuration for the associated plugin.";
        default = "";
      };
    };
  };

  defaultKeyMode = "vim";
  defaultResize = 5;
  defaultShortcut = "b";
  defaultTerminal = "screen";
  defaultShell = null;

  boolToStr = value: if value then "on" else "off";

  tmuxConf = ''
    source ~/.zshrc
  '';

  configPlugins = {
    assertions = [
      (let
        hasBadPluginName = p: !(hasPrefix "tmuxplugin" (pluginName p));
        badPlugins = filter hasBadPluginName cfg.plugins;
      in {
        assertion = badPlugins == [ ];
        message = ''Invalid tmux plugin (not prefixed with "tmuxplugins"): ''
          + concatMapStringsSep ", " pluginName badPlugins;
      })
    ];

    xdg.configFile."tmux/tmux.conf".text = ''
      # ============================================= #
      # Load plugins with Home Manager                #
      # --------------------------------------------- #

      ${(concatMapStringsSep "\n\n" (p: ''
        # ${pluginName p}
        # ---------------------
        ${p.extraConfig or ""}
        run-shell ${if types.package.check p then p.rtp else p.plugin.rtp}
      '') cfg.plugins)}
      # ============================================= #
    '';
  };

in {
  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
    '';

  };
}
