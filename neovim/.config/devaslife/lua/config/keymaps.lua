-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local Util = require("lazyvim.util")

-- Delete a word backwards
keymap.set("n", "db", "vb_d")

-- Select All
keymap.set("v", "<C-a>", "<Esc>gg<S-v>G")

-- JumpList
keymap.set("n", "<C-m>", "<C-i>", opts)

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader>pdb", "<cmd>TodoTelescope keywords=DELETEME<cr>", { desc = "Increase window height" })

vim.keymap.set("n", "<leader>ft", function()
  Util.float_term(nil, { cwd = Util.get_root(), border = "single" })
end, { noremap = true, silent = true, desc = "Resume" })

vim.keymap.set("n", "<leader>gg", function()
  Util.float_term({ "lazygit" }, { cwd = Util.get_root(), border = "double" })
end, { noremap = true, silent = true, desc = "Open lazygit in floating window" })

vim.keymap.set("n", "<leader>tt", function()
  Util.float_term({ "taskwarrior-tui" }, { cwd = Util.get_root(), border = "double" })
end, { noremap = true, silent = true, desc = "Open taskwarrior in floating window" })

local status_ok, rest = pcall(require, "rest-nvim")
local status_ok, obsidian = pcall(require, "obsidian")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    local buff = tonumber(vim.fn.expand("<abuf>"), 10)
    vim.keymap.set("n", "ñrr", rest.run, { noremap = true, buffer = buff })
    -- vim.keymap.set("n", "<leader>dl", "<cmd>ObsidianToday<CR>", { noremap = true, buffer = buff })

    vim.keymap.set( "n", "ñro", '<cmd> lua r=require("rest-nvim");r.setup({result={show_headers=false, show_http_info=false}});r.run()<CR>', { noremap = true, buffer = buff })
    --[[ vim.keymap.set("n", "ñrl", rest.last, { noremap = true, buffer = buff }) ]]
    vim.keymap.set("n", "ñrp", rest.run(true), { noremap = true, buffer = buff })
  end,
})
