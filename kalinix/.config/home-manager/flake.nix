{
  description = "Home Manager configuration of govic";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
	nixvim = import (builtins.fetchGit {
		url = "https://github.com/nix-community/nixvim";
		ref = "main";
	});
    in
    {
      homeConfigurations."govic" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # This passes `inputs` so home.nix/modules see `inputs.nixvim`, etc.
        extraSpecialArgs = { inherit inputs; };

        # Modules to import in configuration
        modules = [
          ./home.nix
          nixvim.homeModules.nixvim
        ];
      };
    };
}
