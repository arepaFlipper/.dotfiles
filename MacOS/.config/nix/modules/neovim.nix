{ config, pkgs, lib, ... }:
let
  # Live dotfiles working tree. mkOutOfStoreSymlink needs an absolute path and
  # links to this MUTABLE location (not the read-only nix store), so lazy.nvim
  # can still write lazy-lock.json, spell files, etc. back into the repo.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
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
