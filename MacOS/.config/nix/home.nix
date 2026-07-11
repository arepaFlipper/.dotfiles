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

    "~/.tmux.conf" = {
      source = ../../../tmux/.tmux.conf;
      target = "${config.home.homeDirectory}/.tmux.conf";
    };

    "~/.tmux.conf.local" = {
      source = ../../../tmux/.tmux.conf.local;
      target = "${config.home.homeDirectory}/.tmux.conf.local";
    };

  } // tmuxScriptEntries;
}

