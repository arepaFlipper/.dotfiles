# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CO.UTF-8";
    LC_IDENTIFICATION = "es_CO.UTF-8";
    LC_MEASUREMENT = "es_CO.UTF-8";
    LC_MONETARY = "es_CO.UTF-8";
    LC_NAME = "es_CO.UTF-8";
    LC_NUMERIC = "es_CO.UTF-8";
    LC_PAPER = "es_CO.UTF-8";
    LC_TELEPHONE = "es_CO.UTF-8";
    LC_TIME = "es_CO.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e";
  services.xserver.windowManager = {
    i3 = {
      enable = true;
    };
  };
  services.xserver.displayManager.gdm.enable = true;
  # Enable i3 as window manager
  services.displayManager.defaultSession = "none+i3";

  console.keyMap = "la-latin1";

  services.printing.enable = true;
  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "yes";
    PasswordAuthentication = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.arepa = {
    isNormalUser = true;
    description = "arepa";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers" ];
    shell = pkgs.zsh;
		packages = [
			pkgs.qutebrowser	
			pkgs.home-manager	
		];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "arepa";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    catppuccin-cursors.frappeYellow
		vim 
		wget
		git
		nodejs_20
		docker
		docker-compose
		flatpak
		flatpak-builder
		fzf

		python3	
		# python312Packages.pip

		stow

		zsh-powerlevel10k
		zsh-autosuggestions
		zsh-syntax-highlighting
		tre-command

		libgcc

    # android SDK
    android-tools

    # Window Manager packages
    xorg.xrandr
    xorg.xbacklight
    xorg.xwininfo
    xclip
  ];

  environment.variables = {
    EDITOR = "vim";
    XCURSOR_THEME = "Catppuccin-Frappe-Sky";
    XCURSOR_SIZE = "24";
  };

  fonts.packages = with pkgs; [ catppuccin-cursors ];

  services.flatpak.enable = true;

  # Enable XDG portal but specify a compatible implementation
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ ];
    config = {
        common = { 
          default = [ "gtk" ];
        };
      };
    };


  networking.firewall.allowedTCPPorts = [ 24800 8000 5432 5173 5444 ];
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs.zsh = {
		enable = true;
		promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
	};

  # android SDK
  programs.adb.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nix.settings.allowed-users = ["arepa"];
  system.stateVersion = "25.05";
}

