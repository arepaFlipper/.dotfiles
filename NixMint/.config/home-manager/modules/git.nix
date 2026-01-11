{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    delta
    lazygit
  ];

  home.file = {
		"~/.gitattributes" = {
			source = "${config.home.homeDirectory}/.dotfiles/git/.gitattributes";
			target = "${config.home.homeDirectory}/.gitattributes";
		};
		"~/.gitconfig" = {
			source = "${config.home.homeDirectory}/.dotfiles/git/.gitconfig";
			target = "${config.home.homeDirectory}/.gitconfig";
		};
		"~/.githooks" = {
			source = "${config.home.homeDirectory}/.dotfiles/git/.githooks";
			target = "${config.home.homeDirectory}/.githooks";
		};
	};

  programs.lazygit = {
  	enable = true;
  };
}

