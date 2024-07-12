{ config, pkgs, ... }:
let
  myAliases = {
    la = "ls -lha";
    nb = "npm run build";
  };
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
in 
{
  programs.zsh = {
    enable = true;
    shellAliases = myAliases;
  };

  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };
}
