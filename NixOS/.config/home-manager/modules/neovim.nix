{ config, pkgs, unstable, nixvim, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
in 
{
	home.packages = with pkgs; [
	    unstable.neovim-unwrapped
	    # Add any Neovim plugins here
	];
	programs.neovim = {
		enable = true;
		package = unstable.neovim-unwrapped;
		defaultEditor = true;
		extraPackages = [
			pkgs.gcc
		];
		plugins = [
		];
		
		extraLuaConfig = ''
		'';
	};
}
