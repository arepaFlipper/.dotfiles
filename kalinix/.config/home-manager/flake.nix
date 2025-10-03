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
    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };
  };

  outputs = { self, nixpkgs, home-manager, claude-code, ... } @ inputs:
  let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      nixvim = import (builtins.fetchGit {
        url = "https://github.com/nix-community/nixvim";
        ref = "main";
      });
      
      gemini-cli-overlay = final: prev: {
        gemini-cli = prev.gemini-cli.overrideAttrs (oldAttrs: {
          version = "0.6.1";
          src = prev.fetchFromGitHub {
            owner = "google-gemini";
            repo = "gemini-cli";
            rev = "10f5da1";
            sha256 = "1QeVFPl6IH1iQFxrDZ0U8eTeLd+fIgSw1CkAiSGaL/s=";
            npmDepsHash = prev.lib.fakeHash;
          };
        });
      };

      pkgs_with_overlay = import nixpkgs {
        system = system;
        overlays = [ gemini-cli-overlay ];
      };
  in
    {
      homeConfigurations."govic" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs_with_overlay;

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
