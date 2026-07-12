{ config, pkgs, inputs, lib, unstable-pkgs, ... }:

{
  # Add packages you want in your shell
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    gemini-cli
    codex
    unstable-pkgs.claude-code
    unstable-pkgs.antigravity-cli
    inputs.hermes-agent.packages.${pkgs.system}.default
  ];

}

