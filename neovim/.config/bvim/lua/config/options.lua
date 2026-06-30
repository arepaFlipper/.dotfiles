-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
vim.g.lazyvim_blink_main = false

-- opt.iskeyword:append("-")

-- xclip is built against glibc-2.40 but Nix injects glibc-2.42 via LD_LIBRARY_PATH,
-- causing a version conflict. Clearing it for xclip lets it use its own RPATH.
vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "clipboard" },
    ["*"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "primary" },
  },
  paste = {
    ["+"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "clipboard", "-o" },
    ["*"] = { "env", "-u", "LD_LIBRARY_PATH", "xclip", "-selection", "primary", "-o" },
  },
  cache_enabled = 0,
}
