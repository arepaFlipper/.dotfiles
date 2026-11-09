{ config, pkgs, inputs, lib, unstable-pkgs, ... }:

{
  home.packages = with pkgs; [
    codex
    unstable-pkgs.opencode
  ];

  home.file."opencode.config" = {
    source = "${config.home.homeDirectory}/.dotfiles/opencode/.config/opencode/opencode.jsonc";
    target = "${config.home.homeDirectory}/.config/opencode/opencode.jsonc";
  };
  home.file."opencode.tui" = {
    source = "${config.home.homeDirectory}/.dotfiles/opencode/.config/opencode/tui.json";
    target = "${config.home.homeDirectory}/.config/opencode/tui.json";
  };
}
