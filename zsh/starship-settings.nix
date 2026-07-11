# Shared Starship prompt layout, used by every non-macOS home-manager module
# (NixOS, NixMint, NixArch, kalinix). Structure/format/icons stay identical
# across machines; only the color palette changes, so each machine gets its
# own visual identity while the config lives in exactly one place. macOS
# keeps its own hand-maintained starship/.config/starship.toml on purpose.
#
# Usage from a shell.nix:
#   programs.starship.settings = import ../../../../zsh/starship-settings.nix {
#     name = "nixos";
#     colors = { arch_blue = "#5277C3"; ... };
#   };
{ name, colors }:
{
  "$schema" = "https://starship.rs/config-schema.json";

  format = "$os$username$hostname[](bg:blue_mid fg:arch_blue)$directory[](fg:blue_mid bg:blue_dark)$git_branch$git_status[](fg:blue_dark bg:midnight_mid)$nodejs$rust$golang$php\${custom.cpu_arch}[](fg:midnight_mid bg:midnight)$time[ ](fg:midnight)\n$character";

  palette = name;
  palettes.${name} = colors;

  os = {
    format = "[ $symbol ]($style)";
    style = "bg:arch_blue fg:text_light";
    disabled = false;
    symbols = {
      Alpaquita = " ";
      Alpine = " ";
      AlmaLinux = " ";
      Amazon = " ";
      Android = " ";
      Arch = " ";
      Artix = " ";
      CachyOS = " ";
      CentOS = " ";
      Debian = " ";
      DragonFly = " ";
      Emscripten = " ";
      EndeavourOS = " ";
      Fedora = " ";
      FreeBSD = " ";
      Garuda = "󰛓 ";
      Gentoo = " ";
      HardenedBSD = "󰞌 ";
      Illumos = "󰈸 ";
      Kali = " ";
      Linux = " ";
      Mabox = " ";
      Macos = " ";
      Manjaro = " ";
      Mariner = " ";
      MidnightBSD = " ";
      Mint = " ";
      NetBSD = " ";
      NixOS = " ";
      Nobara = " ";
      OpenBSD = "󰈺 ";
      openSUSE = " ";
      OracleLinux = "󰌷 ";
      Pop = " ";
      Raspbian = " ";
      Redhat = " ";
      RedHatEnterprise = " ";
      RockyLinux = " ";
      Redox = "󰀘 ";
      Solus = "󰠳 ";
      SUSE = " ";
      Ubuntu = " ";
      Unknown = " ";
      Void = " ";
      Windows = "󰍲 ";
    };
  };

  aws.symbol = "  ";
  buf.symbol = " ";
  bun.symbol = " ";
  c.symbol = " ";
  cpp.symbol = " ";
  cmake.symbol = " ";
  conda.symbol = " ";
  crystal.symbol = " ";
  dart.symbol = " ";
  deno.symbol = " ";
  docker_context.symbol = " ";
  elixir.symbol = " ";
  elm.symbol = " ";
  fennel.symbol = " ";
  fossil_branch.symbol = " ";
  gcloud.symbol = "  ";
  git_commit.tag_symbol = "  ";
  guix_shell.symbol = " ";
  haskell.symbol = " ";
  haxe.symbol = " ";
  hg_branch.symbol = " ";
  java.symbol = " ";
  julia.symbol = " ";
  kotlin.symbol = " ";
  lua.symbol = " ";
  memory_usage.symbol = "󰍛 ";
  meson.symbol = "󰔷 ";
  nim.symbol = "󰆥 ";
  nix_shell.symbol = " ";
  ocaml.symbol = " ";

  # Mirrors p10k's "context" segment: hidden for a plain local shell, shown
  # only when running as root or over SSH.
  username = {
    show_always = false;
    style_user = "bg:arch_blue fg:text_light";
    style_root = "bg:arch_blue fg:text_light";
    format = "[$user]($style)";
  };

  hostname = {
    ssh_symbol = " ";
    ssh_only = true;
    format = "[@$hostname ]($style)";
    style = "bg:arch_blue fg:text_light";
    disabled = false;
  };

  directory = {
    read_only = "󰌾 ";
    style = "fg:text_light bg:blue_mid";
    format = "[ $path ]($style)";
    truncation_length = 3;
    truncate_to_repo = false;
    truncation_symbol = "…/";
    substitutions = {
      "Documents" = "󰈙 ";
      "Downloads" = "󰉍 ";
      "Music" = " ";
      "Pictures" = " ";
    };
  };

  git_branch = {
    symbol = "󰊢";
    style = "bg:blue_dark fg:color_red";
    format = "[[ $symbol ](fg:color_red bg:blue_dark)[ $branch ](fg:white bg:blue_dark)]($style)";
  };

  git_status = {
    style = "bg:blue_dark";
    format = "[[($all_status$ahead_behind )](fg:text_accent bg:blue_dark)]($style)";
  };

  package.symbol = "󰏗 ";

  time = {
    disabled = false;
    format = "[ $time ]($style)";
    style = "fg:text_light bg:midnight";
    time_format = "%I:%M %p";
  };

  python = {
    symbol = " ";
    style = "bg:color_yellow fg:black";
    format = "[[($all_status$ahead_behind )](fg:text_accent bg:color_yellow)]($style)";
    pyenv_version_name = true;
    detect_files = [ ".python-version" "Pipfile" "__init__.py" "pyproject.toml" "requirements.txt" "setup.py" "tox.ini" ];
    disabled = false;
  };

  nodejs = {
    symbol = " ";
    style = "bg:russian_green";
    format = "[[ $symbol ($version) ](fg:fluo_green bg:midnight_mid)]($style)";
  };

  rust = {
    symbol = "󱘗 ";
    style = "bg:midnight_mid";
    format = "[[ $symbol ($version) ](fg:text_accent bg:midnight_mid)]($style)";
  };

  golang = {
    symbol = " ";
    style = "bg:midnight_mid";
    format = "[[ $symbol ($version) ](fg:text_accent bg:midnight_mid)]($style)";
  };

  php = {
    symbol = "";
    style = "bg:midnight_mid";
    format = "[[ $symbol ($version) ](fg:text_accent bg:midnight_mid)]($style)";
  };

  # p10k had a (disabled-by-default) cpu_arch segment; Starship has no
  # built-in equivalent, so this recreates it with a custom module.
  custom.cpu_arch = {
    command = "uname -m";
    when = "true";
    symbol = " ";
    style = "fg:text_accent bg:midnight_mid";
    format = "[ $symbol$output ]($style)";
    disabled = false;
  };

  # Same success/error ❯, vi-mode ❮/V/▶ glyphs p10k's prompt_char used —
  # doubles as the vi-mode indicator, same as it did in p10k.
  character = {
    success_symbol = "[❯](bold fg:fluo_green)";
    error_symbol = "[❯](bold fg:color_red)";
    vimcmd_symbol = "[❮](bold fg:text_accent)";
    vimcmd_replace_one_symbol = "[▶](bold fg:yellow_dark)";
    vimcmd_replace_symbol = "[▶](bold fg:color_yellow)";
    vimcmd_visual_symbol = "[V](bold fg:text_accent)";
  };
}
