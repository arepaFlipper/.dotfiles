# Shared Starship prompt layout, used by every non-macOS home-manager module
# (NixOS, NixMint, NixArch, kalinix). Mirrors the user's old p10k "classic"
# layout: OS icon + path + git on the left (one uniform block background),
# status/duration/user@host/time right-aligned on the same line (a second
# uniform block), with a two-triangle "blade" (powerline flame separators,
# U+E0C0 thick + U+E0C1 thin) marking each block's edge against the empty
# middle. Only the color palette changes per machine — the layout is shared
# in exactly one place. macOS keeps its own hand-maintained
# starship/.config/starship.toml on purpose.
#
# Usage from a shell.nix:
#   programs.starship.settings = import ../../../../zsh/starship-settings.nix {
#     name = "nixos";
#     colors = { blue_dark = "#2C3E66"; ... };
#   };
{ name, colors }:
{
  "$schema" = "https://starship.rs/config-schema.json";

  format = "$os$directory$git_branch$git_status[](fg:blue_dark)$character";
  right_format = "[](fg:midnight)$status$cmd_duration$username$hostname$time";

  palette = name;
  palettes.${name} = colors;

  os = {
    format = "[ $symbol ]($style)";
    style = "bg:blue_dark fg:text_light";
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
      Kali = " ";
      Linux = " ";
      Mabox = " ";
      Macos = " ";
      Manjaro = " ";
      Mariner = " ";
      MidnightBSD = " ";
      Mint = " ";
      NetBSD = " ";
      NixOS = " ";
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

  directory = {
    style = "bg:blue_dark fg:text_light";
    format = "[$path ]($style)";
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
    symbol = "󰊢 ";
    style = "bg:blue_dark fg:color_red";
    format = "[$symbol$branch ]($style)";
  };

  # Matches the old p10k vcs symbols exactly: *N stashed, +N staged, !N modified.
  git_status = {
    style = "bg:blue_dark fg:text_light";
    stashed = "*";
    staged = "+";
    modified = "!";
    format = "([$stashed]($style) )([$staged](fg:fluo_green bg:blue_dark) )([$modified](fg:color_yellow bg:blue_dark) )";
  };

  # Exit status of the last command — always shown (not just on failure),
  # like p10k's status segment.
  status = {
    disabled = false;
    success_symbol = "[✔](fg:fluo_green bg:midnight)";
    symbol = "[✘](fg:color_red bg:midnight)";
    format = "[ $symbol ]($style)";
  };

  cmd_duration = {
    min_time = 2000;
    style = "fg:text_light bg:midnight";
    format = "[$duration ]($style)";
  };

  # Always shown (unlike a typical minimal Starship setup) — p10k's context
  # segment was visible on every prompt, not just root/SSH.
  username = {
    show_always = true;
    style_user = "bg:midnight fg:text_light";
    style_root = "bg:midnight fg:color_red";
    format = "[$user]($style)";
  };

  hostname = {
    ssh_symbol = " ";
    ssh_only = false;
    format = "[@$hostname ]($style)";
    style = "bg:midnight fg:text_light";
    disabled = false;
  };

  time = {
    disabled = false;
    format = "[ $time ]($style)";
    style = "fg:text_light bg:midnight";
    time_format = "%I:%M:%S %p";
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
