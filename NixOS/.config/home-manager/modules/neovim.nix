{ config, pkgs, unstable, nixvim, ... }:
{
  home.packages = with pkgs; [
    neovim-unwrapped
    vimPlugins.nvim-treesitter
    catppuccin
    unzip
    go
    cargo
    openjdk
    python3
    fd
    tree-sitter
    luarocks-nix
    lua5_1
    gcc
    gnumake
    w3m
    solc
    xclip # clipboard provider for bvim (see xdg.configFile below)
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    extraPackages = [
      pkgs.gcc
      pkgs.vimPlugins.nvim-treesitter
    ];
    extraLuaConfig = ''
      -- Add your Lua configuration here
    '';
  };

  # OS-specific clipboard config, sourced by bvim's lua/config/options.lua.
  # NixOS: xclip is built against glibc-2.40 but Nix injects glibc-2.42 via
  # LD_LIBRARY_PATH, causing a version conflict. Clearing it for xclip lets it
  # use its own RPATH.
  xdg.configFile."bvim-local/clipboard.lua".text = ''
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "clipboard" },
        ["*"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "primary" },
      },
      paste = {
        ["+"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "clipboard", "-o" },
        ["*"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "primary", "-o" },
      },
      cache_enabled = 0,
    }
    vim.opt.clipboard = "unnamedplus"
  '';

  home.sessionVariables = {
    LUA_PATH = "${pkgs.luarocks-nix}/share/lua/5.1/?.lua;;";
    LUA_CPATH = "${pkgs.luarocks-nix}/lib/lua/5.1/?.so;;";
  };
  

  # OS-specific plugin overrides, sourced by bvim's lua/config/lazy.lua.
  # NixArch: use the gruvbox colorscheme instead of LazyVim's tokyonight default.
  xdg.configFile."bvim-local/plugins.lua".text = ''
    return {
      { "rose-pine/neovim", priority = 1000, lazy = false, opts = {} },
      { "LazyVim/LazyVim", opts = { colorscheme = "rose-pine" } },
    }
  '';

  home.activation = {
    init = ''
    '';
  };

}

