{ config, pkgs, lib, ... }:

{
  imports = [ ./modules/homebrew.nix ];

  nix.package = pkgs.nixVersions.latest;
  nix.enable = false;
  # services.nix-daemon.enable = true;
  system.stateVersion = 6;

  # nix-darwin now runs activation as root; user-scoped options (e.g.
  # homebrew.*) apply to this primary user. Must match the login user that
  # runs `darwin-rebuild` (and home-manager.users."Christopher").
  system.primaryUser = "Christopher";
  environment.systemPackages = with pkgs; [
    git
    zsh
    repgrep
    fd
    btop
    fzf
    bat
  ];

  users.users.myMacUser = {
    home = "/Users/christopher";
    shell = pkgs.zsh;
  };

}

