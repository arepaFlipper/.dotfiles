{ config, pkgs, ... }:
{
  gtk.enable = true;

  home.pointerCursor = {
    name = "catppuccin-frappe-yellow-cursors";
    package = pkgs.catppuccin-cursors;
    size = 40;
  };


}
