{ config, pkgs, unstable, nixvim, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  home.packages = with pkgs; [
    neovim-unwrapped
    vimPlugins.nvim-treesitter
    unzip
    go
    cargo
    openjdk
    python311Full # This should provide pip
    fd
    tree-sitter
    luarocks-nix
    lua5_1
    gcc
    gnumake
    w3m
    solc
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

  home.sessionVariables = {
    LUA_PATH = "${pkgs.luarocks-nix}/share/lua/5.1/?.lua;;";
    LUA_CPATH = "${pkgs.luarocks-nix}/lib/lua/5.1/?.so;;";
  };

  home.activation = {
    init = ''
    '';
  };

}

