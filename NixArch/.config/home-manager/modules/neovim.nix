{ config, pkgs, unstable, nixvim, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  home.packages = with pkgs; [
    neovim-unwrapped
    # vimPlugins.nvim-treesitter
    # unzip
    # go
    # cargo
    # openjdk
    # fd
    # tree-sitter
    # luarocks-nix
    # lua5_1
    gcc
    gnumake
    # w3m
    # solc
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    extraPackages = [
      pkgs.gcc
      pkgs.vimPlugins.nvim-treesitter
    ];
  };

  # OS-specific plugin overrides, sourced by bvim's lua/config/lazy.lua.
  # NixArch: use the gruvbox colorscheme instead of LazyVim's tokyonight default.
  xdg.configFile."bvim-local/plugins.lua".text = ''
    return {
      { "ellisonleao/gruvbox.nvim", priority = 1000, lazy = false, opts = {} },
      { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox" } },
    }
  '';

  home.sessionVariables = {
    LUA_PATH = "${pkgs.luarocks-nix}/share/lua/5.1/?.lua;;";
    LUA_CPATH = "${pkgs.luarocks-nix}/lib/lua/5.1/?.so;;";
  };

  home.activation = {
    init = ''
      #luarocks install --local neovim
    '';
  };

}

