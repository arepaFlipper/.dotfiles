{
  description = "My first flake!";
  inputs = {
    nixpkgs = "nixpkgs.nixos-24.05"; # the least verbosed way
  };
  outputs  = {self, nixpkgs, ... }:
    let 
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem { # 'nixos' name of the hosname
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
      };
    };
}; 

