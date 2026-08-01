{ unstable-pkgs, nixGLIntel, ... }:
let
  # NOTE: This machine's iGPU (Intel HD 4000, Ivy Bridge) only does OpenGL 4.2
  # via Mesa's crocus driver, below Ghostty's 4.3 minimum, so GL needs to run
  # through llvmpipe (software) instead. Getting EGL to actually initialize
  # here has been unreliable no matter which Mesa provides it: redirecting to
  # the host's Mesa hit glibc ABI mismatches (mixing Nix's loader with the
  # host's newer glibc) and shadowed Nix's own glib/gnutls/lcms2 with
  # incompatible host builds; nixpkgs-unstable's own bundled Mesa worked once
  # in testing but then failed the same way ("Failed to create EGL display")
  # on every later launch, including from a fresh, otherwise-idle session --
  # see https://ghostty.org/docs/help/gtk-opengl-context and
  # https://github.com/ghostty-org/ghostty/discussions/3763. nixGL
  # (https://github.com/nix-community/nixGL) is the actively-maintained,
  # purpose-built fix for exactly this "Nix-built OpenGL app on a
  # non-NixOS host" problem: it bundles its own self-contained, known-good
  # Mesa build (entirely within the Nix store, no host libraries involved at
  # all) and points LD_LIBRARY_PATH/LIBGL_DRIVERS_PATH/etc. at that. Verified
  # reliable here across repeated launches where every other approach was not.
  # nixGLIntel gets EGL initializing reliably, but by default it points at
  # crocus (real hardware), which caps out at OpenGL 4.2 -- one short of
  # Ghostty's 4.3 minimum ("OpenGL version is too old"). LIBGL_ALWAYS_SOFTWARE
  # routes through nixGL's own bundled llvmpipe driver instead, which reports
  # 4.6. Software-rendered GL is fine here since terminal rendering is cheap.
  ghostty-wrapped = unstable-pkgs.writeShellScriptBin "ghostty" ''
    export LIBGL_ALWAYS_SOFTWARE=1
    exec ${nixGLIntel}/bin/nixGLIntel ${unstable-pkgs.ghostty}/bin/ghostty "$@"
  '';

  # nixGLIntel's env vars (LD_LIBRARY_PATH, LIBGL_DRIVERS_PATH, etc.) plus
  # LIBGL_ALWAYS_SOFTWARE above are process-wide once set, so they'd
  # otherwise leak into whatever shell Ghostty spawns for the terminal
  # itself, forcing any GL app run from inside it onto nixGL's bundled
  # software Mesa instead of its own natural resolution. Ghostty's `command`
  # config controls what it actually execs for the terminal, so point it at
  # a shim that drops those vars first.
  ghostty-shell = unstable-pkgs.writeShellScript "ghostty-shell" ''
    unset LD_LIBRARY_PATH LIBGL_DRIVERS_PATH GBM_BACKENDS_PATH \
          LIBVA_DRIVERS_PATH __EGL_VENDOR_LIBRARY_FILENAMES \
          LIBGL_ALWAYS_SOFTWARE
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
