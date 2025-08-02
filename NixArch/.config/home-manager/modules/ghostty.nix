{ pkgs, ... }:
let
  nixgl = import <nixgl> { inherit pkgs; };
  ghostty-nixgl = pkgs.writeShellScriptBin "ghostty" ''
    exec ${nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.ghostty}/bin/ghostty "$@"
  '';
in
{
  home.packages = [
    nixgl.nixGLIntel
    ghostty-nixgl
  ];

  # Optional: Create desktop entry that uses nixGL
  xdg.desktopEntries.ghostty = {
    name = "Ghostty";
    comment = "A fast, feature-rich, and cross-platform terminal emulator";
    exec = "${ghostty-nixgl}/bin/ghostty";
    icon = "ghostty";
    terminal = false;
    categories = [ "System" "TerminalEmulator" ];
  };
}
