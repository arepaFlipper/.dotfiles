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
        alias hmsi="home-manager switch --impure"
        alias nxrb="sudo nixos-rebuild switch --flake ~/.dotfiles/NixOS/.config/home-manager"
        alias xres="sudo systemctl restart display-manager"
        alias kx11="sudo pkill -9 -f 'bin/X vt1'"
        alias ksyn="sudo pkill synergy"
        alias xwork="xrandr --output DP-1 --rate 59.98 --brightness 0.3 --mode 5120x1440"
        source $HOME/.dotfiles/zsh/.zshrc
      '';
    };

    bash = {
      enable = true;
      initExtra = ''
        [[ -f ~/.profile ]] && . ~/.profile
      '';
    };
  };
}

