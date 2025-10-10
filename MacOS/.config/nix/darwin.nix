{ config, pkgs, lib, ... }:

{
  nix.package = pkgs.nixVersions.latest;
  nix.enable = false;
  # services.nix-daemon.enable = true;
  system.stateVersion = 6;
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

