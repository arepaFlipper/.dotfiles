{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    zathura
  ];

  programs.zathura = {
  	enable = true;
    options = {
      default-fg = "#FFFFFF";
      default-bg = "#000000";
    };

    extraConfig = ''
      set recolor true
    '';
  };
}

