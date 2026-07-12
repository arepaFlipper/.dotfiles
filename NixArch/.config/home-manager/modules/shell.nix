{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  home.packages = with pkgs; [
    zsh-autosuggestions
    python313Packages.pip
    zsh-syntax-highlighting
    zoxide
    yt-dlp
    fzf
    oh-my-zsh
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "tmux" "pip" ];
      };

      initContent = ''
        alias hmsi="home-manager switch --impure"
        alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixArch/.config/home-manager"
        #alias claude="$HOME/.claude/local/claude" # It
        source $HOME/.dotfiles/zsh/.zshrc
        if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.nix-profile/bin/zsh" ]; then
            export SHELL="$HOME/.nix-profile/bin/zsh"
            exec "$HOME/.nix-profile/bin/zsh"
        fi
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      # Shared layout lives in starship/starship-layout.toml; only the
      # palette is overridden here. See that file's header for the pattern.
      settings = (builtins.fromTOML (builtins.readFile ../../../../starship/starship-layout.toml)) // {
        palette = "gruvbox";
        palettes.gruvbox = {
          # Gruvbox Dark (https://github.com/morhetz/gruvbox), official hex
          # values, split into one distinct color per prompt section.
          os_fg = "#1d2021"; # OS icon section fg (dark0_hard)
          os_bg = "#83a598"; # OS icon section bg (bright blue)
          blue_dark = "#458588"; # path section bg (neutral blue)
          git_bg = "#b16286"; # git section bg (neutral purple)
          git_fg = "#ebdbb2"; # git branch/status fg (fg1, contrasts with purple git_bg)
          grey0 = "#928374"; # username@hostname section bg (gray)
          midnight = "#1d2021"; # status/duration section bg (dark0_hard)
          text_light = "#ebdbb2"; # Foreground (fg1)
          text_accent = "#8ec07c"; # bright aqua
          fluo_green = "#b8bb26"; # bright green
          color_red = "#fb4934"; # bright red
          color_yellow = "#fabd2f"; # bright yellow
          yellow_dark = "#d65d0e"; # time section bg (neutral orange)
        };
      };
    };
  };
}

