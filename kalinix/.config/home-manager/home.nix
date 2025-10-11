{ config, pkgs, ... }:
let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; };};
in
{

	imports = [
		./modules/shell.nix
    ./modules/ai-support.nix
		./modules/neovim.nix
		./modules/nodejs.nix
		./modules/tmux.nix
	];

  home.username = "govic";
  home.homeDirectory = "/home/govic";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    repgrep
    fd
    btop
    lazygit
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "~/.config/starship.toml" = {
      source = ../../../starship/.config/starship.toml;
      target = "${config.home.homeDirectory}/.config/starship.toml";
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/govic/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
