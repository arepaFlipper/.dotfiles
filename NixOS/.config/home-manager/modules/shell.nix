{ config, pkgs, unstable, ... }:
{
  home = {

    packages = with pkgs; [
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting
        pkgs.zoxide
        yt-dlp
        fzf
        python313Packages.pip
        jq
        jqp
    ];
  };
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "tmux" "pip" ];
      };

      initContent = ''
        # zsh reserves 1 column between RPROMPT and the terminal's right edge
        # by default (ZLE_RPROMPT_INDENT); 0 makes the right bar flush.
        export ZLE_RPROMPT_INDENT=0
        alias hmsi="home-manager switch --impure"
        alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixOS/.config/home-manager"
        alias xres="sudo systemctl restart display-manager"
        alias kx11="sudo pkill -9 -f 'bin/X vt1'"
        alias ksyn="sudo pkill synergy"
        alias xwork="xrandr --output DP-1 --rate 59.98 --brightness 0.3 --mode 5120x1440"
        export PATH="$HOME/.local/bin:$PATH"
        source $HOME/.dotfiles/zsh/.zshrc
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      # Shared layout lives in starship/starship-layout.toml; only the
      # palette is overridden here. See that file's header for the pattern.
      settings = (builtins.fromTOML (builtins.readFile ../../../../starship/starship-layout.toml)) // {
        palette = "foxtrot";
        palettes.foxtrot = {
          # Everforest Dark (https://everforest.vercel.app/palette), split
          # into one distinct color per prompt section.
          os_fg = "#7353BA"; # OS icon section fg
          os_bg = "#5fb8f2"; # OS icon section bg
          blue_dark = "#384B55"; # path section bg (Background Blue)
          git_bg = "#4C3743"; # git section bg (Background Visual)
          git_fg = "#E67E80"; # git branch/status fg (Red, same as color_red)
          grey0 = "#7A8478"; # username@hostname section bg (Grey 0)
          midnight = "#1E2326"; # status/duration section bg (Background Dim)
          text_light = "#D3C6AA"; # Foreground
          text_accent = "#7FBBB3"; # Blue
          fluo_green = "#A7C080"; # Green
          color_red = "#E67E80"; # Red
          color_yellow = "#DBBC7F"; # Yellow
          yellow_dark = "#E69875"; # Orange (time section bg)
        };
      };
    };

    bash = {
      enable = true;
      initExtra = ''
        [[ -f ~/.profile ]] && . ~/.profile
      '';
    };
  };
}

