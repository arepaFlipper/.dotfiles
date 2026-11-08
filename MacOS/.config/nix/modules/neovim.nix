{ config, pkgs, lib, ... }:
let
  # Live dotfiles working tree. mkOutOfStoreSymlink needs an absolute path and
  # links to this MUTABLE location (not the read-only nix store), so lazy.nvim
  # can still write lazy-lock.json, spell files, etc. back into the repo.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # Codeium language server for the windsurf.vim plugin (lua/plugins/codeium.lua).
  # Why this exists: windsurf.vim launches the server without
  # --inference_api_server_url, so it defaults to inference.codeium.com, which
  # no longer accepts connections (TCP timeout). Every completion then failed
  # with "deadline_exceeded" and no ghost text ever showed up. server.codeium.com
  # still serves completions, so this wrapper routes inference there.
  # 1.46.3 = the server version neocodeium uses (windsurf.vim still pins 1.20.8).
  # Fetched straight from the release (not pkgs.codeium) to avoid allowUnfree.
  codeiumVersion = "1.46.3";
  codeiumServer = pkgs.runCommand "codeium-language-server-${codeiumVersion}" {
    src = pkgs.fetchurl {
      url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${codeiumVersion}/language_server_macos_arm.gz";
      hash = "sha256-ANS9FFwrgmRhknpNija9DhO2Znj/RAJhq2GUMZiau6o=";
    };
  } ''
    mkdir -p $out/bin
    gunzip -c $src > $out/bin/language_server_macos_arm
    chmod +x $out/bin/language_server_macos_arm
  '';
  codeiumWrapper = pkgs.writeShellScript "language_server_macos_arm" ''
    exec ${codeiumServer}/bin/language_server_macos_arm "$@" \
      --inference_api_server_url https://server.codeium.com
  '';
  # windsurf.vim loads ~/.codeium/bin/<sha>/language_server_macos_arm, where
  # <sha> comes from ~/.config/codeium/config.json.
  codeiumBinId = "nix-${codeiumVersion}";
in
{
  # Neovim binary, managed by nix instead of Homebrew. Only the binary is
  # owned here — plugins/config stay with lazy.nvim inside the bvim distro,
  # so we deliberately do NOT use home-manager's `programs.neovim`.
  home.packages = [ pkgs.neovim ];

  # Manage the `bvim` distro config as a symlink at ~/.config/bvim.
  # Launched with `NVIM_APPNAME=bvim nvim` (see the `bvim` alias in zsh).
  xdg.configFile."bvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/neovim/.config/bvim";

  # Point windsurf.vim at the wrapped language server (see codeiumWrapper).
  # The API key stays in ~/.codeium/config.json (written by `:Codeium Auth`).
  home.file.".codeium/bin/${codeiumBinId}/language_server_macos_arm".source = codeiumWrapper;
  xdg.configFile."codeium/config.json".text = builtins.toJSON { sha = codeiumBinId; };

  # OS-specific clipboard config, sourced by bvim's lua/config/options.lua.
  # macOS: no X display, so let Neovim auto-detect pbcopy/pbpaste — do NOT set
  # vim.g.clipboard (that's what broke it: "Can't open display: (null)").
  xdg.configFile."bvim-local/clipboard.lua".text = ''
    -- macOS: use Neovim's built-in pbcopy/pbpaste. No vim.g.clipboard override.
    vim.opt.clipboard = "unnamedplus"
  '';

  # OS-specific plugin overrides, sourced by bvim's lua/config/lazy.lua.
  # NixArch: use the gruvbox colorscheme instead of LazyVim's tokyonight default.
  xdg.configFile."bvim-local/plugins.lua".text = ''
    return {
      { "rmehri01/onenord.nvim", priority = 1000, lazy = false, opts = {} },
      { "LazyVim/LazyVim", opts = { colorscheme = "onenord" } },
    }
  '';
}
