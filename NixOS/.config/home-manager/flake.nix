{
  description = "Config the home-manager";  # Description of the flake

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";  # Input for Nixpkgs channel or repository
    unstable.url = "nixpkgs/nixos-unstable";  # Input for Nixpkgs channel or repository
    home-manager.url = "github:nix-community/home-manager/release-25.05";  # Input for Home Manager from GitHub
    home-manager.inputs.nixpkgs.follows = "nixpkgs";  # Ensure Home Manager follows the same Nixpkgs version
    ghostty.url = "github:ghostty-org/ghostty";
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = { self, nixpkgs, unstable, home-manager, ghostty, hermes-agent, ... } @ inputs:
	let 
		lib = nixpkgs.lib;  # Shortcut to access commonly used functions from Nixpkgs
		system = "x86_64-linux";  # Target system architecture

    gemini-cli-overlay = final: prev: {
      gemini-cli = prev.buildNpmPackage rec {
        pname = "gemini-cli";
        version = "0.42.0";

        src = prev.fetchFromGitHub {
          owner = "google-gemini";
          repo = "gemini-cli";
          rev = "v${version}";
          sha256 = "sha256-QYSzJdyjJ5SvPkI/uf/wu8MdM76W+djai6zD38IJpos=";
        };

        npmDepsHash = "sha256-hKNEJ/MAseYs8WLr36h40pYv+5nef8EPhZIfmPKYJPY=";

        nativeBuildInputs = [ prev.makeWrapper prev.pkg-config ];
        buildInputs = [ prev.libsecret ];

        # gemini-cli build steps
        npmBuildScript = "bundle";
        
        postInstall = ''
          # The binary is named 'gemini' in package.json, but user wants 'gemini-cli'
          if [ -f $out/bin/gemini ]; then
            mv $out/bin/gemini $out/bin/gemini-cli
          fi

          # Remove dangling symlinks created by npm workspaces that Nix fixupPhase doesn't like
          find $out/lib/node_modules -type l -xtype l -delete
        '';

        meta = with prev.lib; {
          description = "Google Gemini CLI";
          homepage = "https://github.com/google-gemini/gemini-cli";
          license = licenses.asl20;
          platforms = platforms.linux;
        };
      };
    };

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ gemini-cli-overlay ];
    };

    unstable-pkgs = import unstable {
      inherit system;
      config.allowUnfree = true;
    };

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
        extraSpecialArgs = { 
          inherit ghostty inputs; 
          unstable-pkgs = unstable-pkgs;
        };
				modules = [ 
				  ./home.nix
				];  # List of modules to include in the Home Manager configuration
			};
		};
	};
}
