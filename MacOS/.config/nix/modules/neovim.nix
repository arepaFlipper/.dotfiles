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
}
