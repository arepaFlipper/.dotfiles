{
  description = "Nix-darwin + Home Manager configuration for macOS";

  inputs = {
    unstable.url = "nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, nix-darwin, home-manager, unstable, ... } @ inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      unstable-pkgs = import unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      darwinConfigurations = {
        "Cristians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit self inputs unstable-pkgs;
          };
          modules = [
            ./darwin.nix

            home-manager.darwinModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-bak";
              home-manager.extraSpecialArgs = {
                inherit inputs unstable-pkgs;
              };

              users.users."Christopher".home = "/Users/christopher";
              home-manager.users."Christopher" = import ./home.nix;
            }
          ];
        };
      };

      users.users."Christopher" = {
        name = "Christopher";
        isNormalUser = true;
        home = "/Users/christopher";
        shell = pkgs.zsh;
      };
    };
}
