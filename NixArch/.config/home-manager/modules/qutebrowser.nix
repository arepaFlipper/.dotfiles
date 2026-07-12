{ unstable-pkgs, ... }:
let
  # Same root cause as ghostty.nix: this machine's Intel HD 4000 (Ivy
  # Bridge) fails GLX/EGL init against the Nix closure's own Mesa, and
  # QtWebEngine aborts (SIGABRT) rather than falling back gracefully.
  # Routing GL through the host's Mesa + forcing software rendering fixes
  # it. Unlike ghostty, qutebrowser doesn't spawn a login shell as a child
  # (its child processes are just itself re-exec'd for Chromium's
  # multi-process model), so there's no LD_LIBRARY_PATH-leak-crashes-zsh
  # concern here and no need for the "command" shim trick.
  #
  # That alone gets the browser chrome (window/tabs) rendering, but web
  # content stays blank: Chromium spawns a *separate* GPU process for
  # page compositing, which fails to create a GL command buffer inside
  # its own sandbox even with the vars above ("GpuControl.CreateCommand
  # Buffer" transient failure). --disable-gpu/-compositing skips that
  # process entirely and rasterizes content on the CPU in the renderer
  # process instead, which works reliably on this hardware.
  qutebrowser-wrapped = unstable-pkgs.writeShellScriptBin "qutebrowser" ''
    export LIBGL_ALWAYS_SOFTWARE=1
    export LIBGL_DRIVERS_PATH=/usr/lib/dri
    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json
    export LD_LIBRARY_PATH="/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    exec ${unstable-pkgs.qutebrowser}/bin/qutebrowser \
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
