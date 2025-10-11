{ config, pkgs, inputs, lib, ... }:
{

  home.packages = with pkgs; [
    fzf
    fd
    lazygit
    starship
    unzip
  ];

  # Programs
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initContent = ''
      echo "Welcome Crhistofer  "
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
    '';

    shellAliases = {
      la = "ls -lha";
      # put other aliases you remember
    };

    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [ "git" "tmux" "autopep8" "pip" "python" "pyenv"];
      theme = "robbyrussell";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Minimum Configuration: Customizing the prompt
  };

  programs.bash = {
    enable = false;
    bashrcExtra = ''
      zsh
    '';
  };

  # Optionally include zoxide etc.
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

}
