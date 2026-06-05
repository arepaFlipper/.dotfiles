{ config, pkgs, inputs, lib, ... }:

{
  # Add packages you want in your shell
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    gemini-cli
    codex
    claude-code
    inputs.hermes-agent.packages.${pkgs.system}.default
    codex
  ];

}

