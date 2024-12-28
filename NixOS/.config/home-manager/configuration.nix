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
  #services.xserver.layout = "us";
  services.xserver.xkb.layout = "us";
  #services.xserver.xkbOptions = "eurosign:e";
  services.xserver.xkb.options = "eurosign:e";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  users.users.cris = {
    isNormalUser = true;
    description = "cris";
    extraGroups = [ "networkmanager" "wheel" "docker" "kvm" "adbusers" ];
    shell = pkgs.zsh;
		packages = [
			pkgs.alacritty	
			pkgs.qutebrowser	
			pkgs.home-manager	
		];
  };

  # services.xserver.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "cris";
  services.displayManager.autoLogin.user = "cris";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
		vim 
		wget
		tmux
		git
		nodejs_20
		docker
		docker-compose
		openssl_3_3
		flatpak
		flatpak-builder
		fzf

		python3	
		# python312Packages.pip

		synergy
		stow

		zsh-powerlevel10k
		zsh-autosuggestions
		zsh-syntax-highlighting
		tre-command

		libgcc

    # android SDK
    android-tools

  ];

  environment.variables.EDITOR = "vim";

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  networking.firewall.allowedTCPPorts = [ 24800 8000 ];
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
	nix.settings.allowed-users = ["cris"];
  system.stateVersion = "24.05";
}

