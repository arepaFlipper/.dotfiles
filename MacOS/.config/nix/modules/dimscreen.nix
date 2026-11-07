{ config, pkgs, lib, ... }:

{
  # `dimscreen 0.5` dims below the hardware minimum, `dimscreen 1 invert` inverts
  # colors, `dimscreen 0.4 invert` does both. It scales the display gamma table,
  # which macOS resets when the process exits, so Ctrl+C restores the screen.
  # Runs with the system /usr/bin/swift (Xcode Command Line Tools), not a nix one.
  home.packages = [
    (pkgs.writeShellScriptBin "dimscreen" ''
      exec /usr/bin/swift ${./dimscreen.swift} "$@"
    '')
  ];
}
