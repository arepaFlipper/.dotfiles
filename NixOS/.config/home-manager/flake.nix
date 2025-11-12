{
  description = "Config the home-manager";  # Description of the flake

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";  # Input for Nixpkgs channel or repository
    unstable.url = "nixpkgs/nixos-unstable";  # Input for Nixpkgs channel or repository
    home-manager.url = "github:nix-community/home-manager/release-25.05";  # Input for Home Manager from GitHub
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  # Ensure Home Manager follows the same Nixpkgs version
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ghostty, ... } @ inputs:
	let 
		lib = nixpkgs.lib;  # Shortcut to access commonly used functions from Nixpkgs
		system = "x86_64-linux";  # Target system architecture
		unstable = unstable.legacyPackages.${system};  # Legacy packages for the specified system

    gemini-cli-overlay = final: prev: {
      gemini-cli = prev.stdenv.mkDerivation rec {
        pname = "gemini-cli";
        version = "0.6.1";

        src = prev.fetchFromGitHub {
          owner = "google-gemini";
          repo = "gemini-cli";
          rev = "10f5da1";
          sha256 = "1QeVFPl6IH1iQFxrDZ0U8eTeLd+fIgSw1CkAiSGaL/s=";
        };

        buildInputs = [ prev.nodejs prev.makeWrapper ];
        nativeBuildInputs = [ prev.makeWrapper ];

        buildPhase = ''
          runHook preBuild
          npm install
          npm run build || make build || true
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/lib/gemini-cli $out/bin
          cp -r ./* $out/lib/gemini-cli
          makeWrapper ${prev.nodejs}/bin/node $out/bin/gemini-cli \
            --add-flags "$out/lib/gemini-cli/index.js"
          runHook postInstall
        '';

        meta = with prev.lib; {
          description = "Google Gemini CLI";
          homepage = "https://github.com/google-gemini/gemini-cli";
          license = licenses.asl20;
          platforms = platforms.linux;
        };
      };
    };




    pkgs_with_overlay = import nixpkgs {
      system = system;
      overlays = [ gemini-cli-overlay ];
    };
    pkgs = pkgs_with_overlay;

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

