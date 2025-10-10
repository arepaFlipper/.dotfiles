{
  description = "Nix-darwin + Home Manager configuration for macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";  # or "aarch64-darwin" on Apple Silicon
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      darwinConfigurations = {
        "Cristians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./darwin.nix

            home-manager.darwinModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              users.users."Christopher".home = "/Users/christopher";
              home-manager.users."Christopher" = import ./home.nix;
            }
          ];
        };
      };
      users.users."Christopher" = {
        name = "Christopher";
        isNormalUser = true;   # optional
        home = "/Users/christopher";
        shell = pkgs.zsh;      # or whichever shell
        # other user settings...
      };


    };
}

