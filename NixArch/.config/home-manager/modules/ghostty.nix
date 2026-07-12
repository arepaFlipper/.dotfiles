{ unstable-pkgs, ... }:
let
  # NOTE:  This machine's iGPU (Intel HD 4000, Ivy Bridge) caps out at OpenGL 4.2
  # via Mesa's crocus driver, but Ghostty requires OpenGL 4.3+. The Nix
  # closure's own Mesa also fails earlier than that, at EGL display
  # creation, on this host's kernel/driver combo (a version-skew issue --
  # see https://ghostty.org/docs/help/gtk-opengl-context). Pointing the
  # dynamic linker at the host's Mesa (which has a proper EGL/crocus setup)
  # fixes EGL init; LIBGL_ALWAYS_SOFTWARE then routes rendering through
  # llvmpipe, which reports OpenGL 4.6 and satisfies Ghostty's minimum.
  # Software-rendered GL is fine here since terminal rendering is cheap.
  ghostty-wrapped = unstable-pkgs.writeShellScriptBin "ghostty" ''
    export LIBGL_ALWAYS_SOFTWARE=1
    export LIBGL_DRIVERS_PATH=/usr/lib/dri
    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
    export LD_LIBRARY_PATH="/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec ${unstable-pkgs.ghostty}/bin/ghostty "$@"
  '';

  # NOTE: LD_LIBRARY_PATH above is process-wide once set, so it also leaks into
  # whatever shell Ghostty spawns for the terminal itself -- and a
  # Nix-built zsh loading /usr/lib over its own glibc/ncurses segfaults
  # immediately (confirmed: `LD_LIBRARY_PATH=/usr/lib zsh` dumps core).
  # That's why the window used to open and close again within ~2s: the
  # GL context was fine, but the login shell crashed right after spawning.
  # Ghostty's `command` config controls what it actually execs for the
  # terminal, so point it at a shim that drops the GL-only env vars first.
  ghostty-shell = unstable-pkgs.writeShellScript "ghostty-shell" ''
    unset LD_LIBRARY_PATH LIBGL_ALWAYS_SOFTWARE LIBGL_DRIVERS_PATH __EGL_VENDOR_LIBRARY_FILENAMES
    exec "$SHELL" -l
  '';
in
{
  home.packages = [ ghostty-wrapped ];

  xdg.configFile."ghostty/config".text = ''
    command = ${ghostty-shell}
  '';

  xdg.desktopEntries.ghostty = {
    name = "Ghostty";
    comment = "A fast, feature-rich, and cross-platform terminal emulator";
    exec = "${ghostty-wrapped}/bin/ghostty";
    icon = "ghostty";
    terminal = false;
    categories = [ "System" "TerminalEmulator" ];
  };
}
