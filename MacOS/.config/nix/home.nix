{ config, pkgs, lib, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; };};
  imports = [ <home-manager/nix-darwin> ];
  tmuxDir = ../../../tmux;
  tmuxScriptEntries =
    let
      files = builtins.readDir tmuxDir;
      isScript = name: type:
        type == "regular" &&
        (lib.hasSuffix ".tmux.sh" name || name == "tmoxpen.sh");
    in
      lib.mapAttrs' (name: _:
        lib.nameValuePair ".tmux/${name}" {
          source = "${tmuxDir}/${name}";
          executable = true;
        }
      ) (lib.filterAttrs isScript files);
in
{
  home.homeDirectory = "/Users/christopher";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    starship
  ];

  imports = [
    ./modules/shell.nix
    ./modules/tmux.nix
    ./modules/neovim.nix
  ];

  home.file = {
    "~/.config/starship.toml" = {
      source = ../../../starship/.config/starship.toml;
      target = "${config.home.homeDirectory}/.config/starship.toml";
    };

    # NOTE: ~/.tmux.conf and ~/.tmux.conf.local are intentionally NOT symlinked
    # here. modules/tmux.nix now owns tmux the NixArch way: programs.tmux writes
    # ~/.config/tmux/tmux.conf which sources the shared framework and selects the
    # dracula theme via TMUX_CONF_LOCAL. Symlinking ~/.tmux.conf would shadow that
    # XDG config and reintroduce a second source of truth.

  } // tmuxScriptEntries;
}

