{
  description = "Home Manager configuration of arepa";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "nixpkgs/nixos-25.05";  # Input for Nixpkgs channel or repository
    unstable.url = "nixpkgs/nixos-unstable";  # Input for Nixpkgs channel or repository
    home-manager.url = "github:nix-community/home-manager/release-25.05";  # Input for Home Manager from GitHub
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  # Ensure Home Manager follows the same Nixpkgs version
    nixgl.url = "github:nix-community/nixGL";  # Wraps Nix-built OpenGL apps to use a working Mesa on non-NixOS hosts
  };

  outputs = { self, nixpkgs, unstable, home-manager, nixgl, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      unstable-pkgs = import unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations."arepa" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit inputs;
          unstable-pkgs = unstable-pkgs;
          nixGLIntel = nixgl.packages.${system}.nixGLIntel;
        };

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
