{ inputs, config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
in 
{
  imports = [
    ./modules/shell.nix
    #./modules/ghostty.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/syncthing.nix
    ./modules/cursor.nix
    ./modules/git.nix
    ./modules/window_manager.nix
  ];
  home.username = "arepa";
  home.homeDirectory = "/home/arepa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.packageOverrides = pkgs: {
    qutebrowser = pkgs.qutebrowser.override {
      python3 = pkgs.python3.override {
        packageOverrides = python-self: python-super: {
          lxml-html-clean = python-super.lxml-html-clean.overridePythonAttrs (oldAttrs: {
            doCheck = false;  # Skip tests
          });
        };
      };
    };
  };

  home.packages = with pkgs; [
    ripgrep
    ffmpeg
    nodePackages_latest.nodejs
    scrcpy

    libreoffice
    ghostty
    qutebrowser
    yazi
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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
  #  /etc/profiles/per-user/arepa/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    #EDITOR = "vim";
    SHELL = "zsh";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
