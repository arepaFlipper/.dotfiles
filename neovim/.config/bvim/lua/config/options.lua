-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_blink_main = false

-- opt.iskeyword:append("-")

-- OS-specific settings (notably the clipboard provider) are managed by the
-- per-OS Nix module, which writes ~/.config/bvim-local/clipboard.lua:
--   * macOS: MacOS/.config/nix/modules/neovim.nix
--   * NixOS: NixOS/.config/home-manager/modules/neovim.nix
-- Sourced here if present; safe to be absent (e.g. running bvim without nix).
local xdg = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
local os_local = xdg .. "/bvim-local/clipboard.lua"
if vim.uv.fs_stat(os_local) then
	dofile(os_local)
end
