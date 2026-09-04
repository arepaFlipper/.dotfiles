{ unstable-pkgs, nixGLIntel, ... }:
let
  # Same root cause as ghostty.nix: this machine's Intel HD 4000 (Ivy Bridge)
  # fails GLX/EGL init against the Nix closure's own Mesa, and QtWebEngine
  # aborts (SIGABRT) rather than falling back gracefully.
  #
  # This used to be worked around by pointing LIBGL_DRIVERS_PATH /
  # __EGL_VENDOR_LIBRARY_FILENAMES / LD_LIBRARY_PATH at the *host's* /usr/lib
  # Mesa. That is the trap ghostty.nix warns about, and it eventually bit:
  # once Arch's glibc moved ahead of the Nix closure's (2.44 vs 2.42), the
  # host libc got loaded under Nix's older ld.so and every launch died with
  #   /usr/lib/libc.so.6: undefined symbol: __pointer_chk_guard, GLIBC_PRIVATE
  # Mixing the host's libraries into a Nix process is only ever one host
  # upgrade away from breaking, so don't.
  #
  # nixGL supplies its own self-contained, known-good Mesa entirely from the
  # Nix store (no host libraries involved), and LIBGL_ALWAYS_SOFTWARE routes
  # through its bundled llvmpipe instead of crocus, which is what this GPU
  # needs. Unlike ghostty, qutebrowser doesn't spawn a login shell as a child
  # (its children are just itself re-exec'd for Chromium's multi-process
  # model), so there's no env-leak-into-your-shell concern and no need for
  # the "command" shim trick.
  #
  # That gets the browser chrome (window/tabs) rendering, but web content
  # stays blank: Chromium spawns a *separate* GPU process for page
  # compositing, which fails to create a GL command buffer inside its own
  # sandbox even with the above ("GpuControl.CreateCommandBuffer" transient
  # failure). --disable-gpu/-compositing skips that process entirely and
  # rasterizes content on the CPU in the renderer process instead, which
  # works reliably on this hardware.
  qutebrowser-wrapped = unstable-pkgs.writeShellScriptBin "qutebrowser" ''
    export LIBGL_ALWAYS_SOFTWARE=1
    exec ${nixGLIntel}/bin/nixGLIntel ${unstable-pkgs.qutebrowser}/bin/qutebrowser \
      --qt-flag disable-gpu \
      --qt-flag disable-gpu-compositing \
      "$@"
  '';
in
{
  home.packages = [ qutebrowser-wrapped ];

  xdg.desktopEntries.qutebrowser = {
    name = "qutebrowser";
    comment = "A keyboard-driven, vim-like browser based on Python and Qt";
    exec = "${qutebrowser-wrapped}/bin/qutebrowser %u";
    icon = "qutebrowser";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [ "text/html" "text/xml" "application/xhtml+xml" "x-scheme-handler/http" "x-scheme-handler/https" ];
  };
}
