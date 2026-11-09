# OpenCode Configuration

This directory stores the shared global configuration for [OpenCode](https://opencode.ai), structured so it works seamlessly with both **Nix Home Manager** and **GNU Stow** (`stow opencode`).

## Directory Structure

```text
opencode/
├── README.md
└── .config/
    └── opencode/
        ├── opencode.jsonc   # Core runtime, models, providers, MCP, permissions, agents
        └── tui.json         # Terminal UI (TUI): keybinds, theme, cursor, leader_timeout
```

Optional directories that can also live under `.config/opencode/`:
- `agents/<name>.md` — Custom global agents
- `commands/<name>.md` — Custom global `/slash` commands
- `skills/<name>/SKILL.md` — Custom global agent skills
- `plugins/<name>.ts` — Local global plugins

---

## Configuration Files Explained

OpenCode splits its configuration into **two distinct files** with separate JSON schemas. Unknown keys in either file will fail schema validation.

### 1. `opencode.jsonc` (Core / Server Config)
- **Schema:** `https://opencode.ai/config.json`
- **Purpose:** Controls the agent runtime and backend behavior.
- **Common settings:**
  - `model` / `small_model` (e.g., `"anthropic/claude-sonnet-4-6"`)
  - `default_agent` (e.g., `"build"`)
  - `provider` / `enabled_providers` / `disabled_providers`
  - `permission` (tool approval rules for `bash`, `edit`, `read`, etc.)
  - `mcp` (local and remote Model Context Protocol servers)
  - `plugin`, `skills`, `instructions`, `formatter`, `lsp`

### 2. `tui.json` (Terminal UI Config)
- **Schema:** `https://opencode.ai/tui.json`
- **Purpose:** Controls the interactive terminal interface appearance and shortcuts.
- **Common settings:**
  - `theme` — UI color theme
  - `leader_timeout` — Time in ms to wait after pressing the leader key (default: `2000`)
  - `cursor` — `{ "style": "block" | "underline" | "line" | "default", "blinking": true }`
  - `keybinds` — Shortcut overrides (`leader`, `command_list`, `editor_open`, `app_exit`, etc.)
  - `scroll_speed`, `scroll_acceleration`, `diff_style`, `mouse`, `prompt`, `attention`

*(Note: `cli.json` is not a valid OpenCode configuration file and is ignored by OpenCode.)*

---

## Configuration Hierarchy (Precedence)

OpenCode deep-merges configurations from **lowest to highest precedence** (later scopes override earlier ones, while non-conflicting settings are preserved):

### `opencode.json(c)` Precedence
1. **Global user config:** `~/.config/opencode/opencode.json(c)`
2. **Project direct configs** (walked from filesystem root down to current working directory): `<parent>/opencode.json(c)` -> `./opencode.json(c)`
3. **Project `.opencode/` directory configs** (walked from farthest to closest): `./.opencode/opencode.json(c)`
4. **Environment overrides:** `OPENCODE_CONFIG=/path/to/file.json` and `OPENCODE_CONFIG_CONTENT`
5. **System / Managed config (highest):** `/etc/opencode/opencode.json(c)` (Linux) or `/Library/Application Support/opencode/opencode.json(c)` (macOS)

### `tui.json(c)` Precedence
1. **Built-in TUI defaults**
2. **Global TUI config:** `~/.config/opencode/tui.json(c)`
3. **Project TUI config:** `./tui.json(c)` or `./.opencode/tui.json(c)`
4. **Environment override:** `OPENCODE_TUI_CONFIG=/path/to/tui.json`

---

## Managing Links

### Via Nix Home Manager
Configured in `modules/ai-support.nix` across `NixOS`, `NixArch`, and `MacOS`:
```nix
  home.file."opencode.config" = {
    source = "${config.home.homeDirectory}/.dotfiles/opencode/.config/opencode/opencode.jsonc";
    target = "${config.home.homeDirectory}/.config/opencode/opencode.jsonc";
  };
  home.file."opencode.tui" = {
    source = "${config.home.homeDirectory}/.dotfiles/opencode/.config/opencode/tui.json";
    target = "${config.home.homeDirectory}/.config/opencode/tui.json";
  };
```

### Via GNU Stow
From `~/.dotfiles`:
```bash
stow opencode
```
*(Note: `.stow-local-ignore` automatically ignores `README.md`.)*
