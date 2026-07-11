{ config, pkgs, lib, ... }:
{
  # Declarative Homebrew, driven by nix-darwin. On `darwin-rebuild switch`,
  # nix-darwin writes a Brewfile and runs `brew bundle` to match these lists.
  # Homebrew itself must already be installed (it is, at /opt/homebrew).
  homebrew = {
    enable = true;

    # Export HOMEBREW_BUNDLE_FILE_GLOBAL pointing at the Brewfile this module
    # generates, so `brew bundle` / `brew bundle check --global` use it instead
    # of looking for a (nonexistent) ~/.Brewfile.
    global.brewfile = true;

    onActivation = {
      autoUpdate = false; # don't run `brew update` on every switch (slow)
      upgrade = false;    # don't upgrade already-installed formulae on every switch
      # "none": leave undeclared packages alone (safe default while migrating).
      # "uninstall": remove any formula/cask not listed below.
      # "zap": same, and also delete their data/config.
      cleanup = "zap";
    };

    # Third-party taps needed by some formulae/casks below.
    taps = [
      "asmvik/formulae"
      "derailed/k9s"
      "deskflow/tap"
      "nikitabobko/tap"
      "stripe/stripe-cli"
    ];

    # CLI formulae (from `brew leaves`).
    # NOTE: entries marked (nix) also exist in nixpkgs — see the message from
    # Claude. Consider dropping those here and installing via nix instead so a
    # tool isn't provided twice. `neovim` was intentionally removed (now on nix).
    brews = [
      "cliclick"
      "cocoapods"
      "docker"
      "docker-compose"
      "fabric-ai"
      "fd"            # (nix) also in shell.nix
      "ffmpeg"
      "fzf"           # (nix) also in shell.nix
      "gemini-cli"
      "git-delta"     # (nix) available as pkgs.delta
      "htop"          # (nix)
      "imagemagick"
      "jq"            # (nix)
      "lazygit"       # (nix) also in shell.nix
      "neofetch"
      "nvm"
      "pipx"
      "poppler"
      "python@3.12"
      "rbenv"
      "ripgrep"       # (nix)
      "sevenzip"
      "solidity"
      "stow"
      "syncthing"
      "tailscale"
      "terraform"
      "tree"          # (nix)
      "vercel-cli"
      "w3m"
      "xclip"
      "yarn"
      "yazi"          # (nix)
      "yt-dlp"
      "zoxide"        # (nix) also managed via programs.zoxide in shell.nix
    ];

    # GUI apps and fonts (from `brew list --cask`).
    casks = [
      "aerospace"       # nikitabobko/tap
      "amitv87-pip"
      "brave-browser"
      "claude-code"
      "font-jetbrains-mono-nerd-font"
      "font-nimbus-sans-l"
      "font-symbols-only-nerd-font"
      "ghostty"
      "hammerspoon"
      "iterm2"
      "obsidian"
      "rustdesk"
      "touchswitcher"
      "warp"
    ];

    # Mac App Store apps go here as { "App Name" = <id>; } (needs `mas`).
    # masApps = { };
  };
}
