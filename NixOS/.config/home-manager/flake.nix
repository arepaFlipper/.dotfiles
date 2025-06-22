{
  description = "Config the home-manager";  # Description of the flake

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";  # Input for Nixpkgs channel or repository
    unstable.url = "nixpkgs/nixos-unstable";  # Input for Nixpkgs channel or repository
    home-manager.url = "github:nix-community/home-manager/release-25.05";  # Input for Home Manager from GitHub
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  # Ensure Home Manager follows the same Nixpkgs version
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ghostty, ... }:
	let 
		lib = nixpkgs.lib;  # Shortcut to access commonly used functions from Nixpkgs
		system = "x86_64-linux";  # Target system architecture
		pkgs = nixpkgs.legacyPackages.${system};  # Legacy packages for the specified system
		unstable = unstable.legacyPackages.${system};  # Legacy packages for the specified system
	in {
		nixosConfigurations = {  # NixOS configurations section
			nixos = lib.nixosSystem {  # Define a NixOS system configuration named 'nixos'
				inherit system;  # Inherit the system architecture
				modules = [ 
          ./configuration.nix 
        ];  # List of modules to include in the NixOS configuration
			};
		};
		homeConfigurations = {  # Home Manager configurations section
			cris = home-manager.lib.homeManagerConfiguration {  # Define a Home Manager configuration named 'cris'
				inherit pkgs;  # Inherit package set for Home Manager configuration
        extraSpecialArgs = { inherit ghostty; };
				modules = [ 
          ./home.nix
        ];  # List of modules to include in the Home Manager configuration
			};
		};
	};
}

