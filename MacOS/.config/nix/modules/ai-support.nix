{ config, pkgs, inputs, lib, unstable-pkgs, ... }:

{
  home.packages = with pkgs; [
    codex
    unstable-pkgs.opencode
  ];
}
