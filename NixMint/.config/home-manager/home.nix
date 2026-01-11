{ inputs, config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
in 
{
  imports = [
    ./modules/shell.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/syncthing.nix
    ./modules/cursor.nix
    ./modules/git.nix
    ./modules/window_manager.nix
  ];

  home = {
		username = "vicky";
		homeDirectory = "/home/vicky";
		stateVersion = "25.11";

		packages = with pkgs; [
			ripgrep
			ffmpeg
			nodePackages_latest.nodejs
			scrcpy
			docker-compose
			libreoffice
			ghostty
			qutebrowser
			yazi
		];

		sessionVariables = {
			#EDITOR = "vim";
			SHELL = "zsh";
		};
	};

  programs.home-manager.enable = true;
}
