{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {

	home = {
		packages = with pkgs; [
			python315
			zoxide
			yt-dlp
			fzf
			unzip
			starship
			fd
		];

		file = {
			".p10k.zsh".source = ../../../../zsh/.p10k.arch.zsh;
			".config/starship.toml".source = ../../../../starship/.config/mint.toml;
			".config/bvim".source = ../../../../neovim/.config/bvim;
		};

	};

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      initContent = ''
        source ~/.p10k.zsh
        alias hmsi="home-manager switch --flake ~/.dotfiles/NixMint/.config/home-manager --impure"
        alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixMint/.config/home-manager"
      '';

			shellAliases = {
				la = "ls -lha";
			};

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "tmux" "pip" ];
        theme = "robbyrussell";
      };

    };

		starship = {
			enable = true;
			enableZshIntegration = true;
		};

		bash = {
			enable = false;
			bashrcExtra = ''
				zsh
			'';
		};

		zoxide = {
			enable = true;
			enableZshIntegration = true;

		};

  };
}

