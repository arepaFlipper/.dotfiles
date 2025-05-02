-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Set leader key
vim.g.mapleader = " "

-- Helper to pick a random emoji
local function get_random_emoji()
  -- Load emojis
  local emojis = dofile(vim.fn.expand("~/.dotfiles/neovim/.config/snippets_lua/emojis.lua")).Emojis
  local emoji = emojis[math.random(#emojis)]
  return emoji
end

local function compute_color_code(ln)
  local code = math.floor(250 - 50000 * ((ln + 40.5) ^ 0.9 + 6) ^ -1.5) * 0x10000
  code = code * 255
  return "#" .. string.sub(string.format("%x", code), 1, 6)
end

-- Main function to insert fancy console.log
local function insert_js_log()
  local file_name = vim.fn.expand("%:t")
  local line_number = vim.fn.line(".")
  local selected_text = vim.fn.getreg("+"):gsub("[%r\n]+", "")
  -- Load emojis
  local emojis = dofile(vim.fn.expand("~/.dotfiles/neovim/.config/snippets_lua/emojis.lua")).Emojis
  local emoji = emojis[math.random(#emojis)]
  local color = compute_color_code(line_number)

  -- Get selected text (yanked to + register)
  local selected_text = vim.fn.getreg("+")
  if not selected_text or selected_text == "" then
    vim.notify("No text selected", vim.log.levels.ERROR)
    return
  end

  -- Get current file name
  local file_name = vim.fn.expand("%:t")
  -- Get current line number
  local line_number = vim.fn.line(".")

  -- Build console.log string

  local log1 = string.format(
    "console.log(`%s%%c%s:%d - %s`, 'font-weight:bold; background:%s;color:#fff;'); //DELETEME:",
    emoji,
    file_name,
    line_number,
    selected_text,
    color
  )
  local log2 = string.format("console.log(%s); // DELETEME:", selected_text)

  vim.api.nvim_put({ log1, log2 }, "l", true, true)
end

-- Make the function globally accessible
_G.insert_js_log = insert_js_log

-- Create autocommand for JS/TS files
vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "JSLogMacro",
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  callback = function()
    -- Define macro in register p
    -- Steps:
    -- 1. Escape visual mode
    -- 2. Reselect visual selection
    -- 3. Yank selection to + register
    -- 4. Escape
    -- 5. Call Lua function directly
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
    local enter = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
    local macro = table.concat({
      esc,
      'gv"+y',
      esc,
      ":lua insert_js_log()",
      enter,
    })
    vim.fn.setreg("p", macro)
  end,
})

local colors = {
  "\\x1b[1;30;41m",
  "\\x1b[1;30;42m",
  "\\x1b[1;30;43m",
  "\\x1b[1;30;44m",
  "\\x1b[1;30;45m",
  "\\x1b[1;30;46m",
  "\\x1b[1;30;47m",
  "\\x1b[1;37;41m",
  "\\x1b[1;37;42m",
  "\\x1b[1;37;44m",
  "\\x1b[1;37;45m",
  "\\x1b[1;37;46m",
}

local function get_random_emoji()
  local emojis = dofile(vim.fn.expand("~/.dotfiles/neovim/.config/snippets_lua/emojis.lua")).Emojis
  return emojis[math.random(#emojis)]
end

local function get_random_color()
  return colors[math.random(#colors)]
end

-- 3. Main inserter for Python debug print
local function insert_py_log()
  local emoji = get_random_emoji()
  local color = get_random_color()
  local file = vim.fn.expand("%:t")
  local line = vim.fn.line(".")
  local txt = vim.fn.getreg("+"):gsub("[%r\n]+", "")

  if txt == "" then
    vim.notify("No text selected", vim.log.levels.ERROR)
    return
  end

  local log1 = string.format('  print("""%s   %s%s:%d  %s:""") ## DELETEME:', emoji, color, file, line, txt)
  local log2 = string.format("  print(%s) ## DELETEME:", txt)
  local log3 = "  print('\\x1b[0m') ## DELETEME:"

  vim.api.nvim_put({ log1, log2, log3 }, "l", true, true)
end

_G.insert_py_log = insert_py_log

-- 4. Autocommand & macro for Python files
vim.api.nvim_create_augroup("PyLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "PyLogMacro",
  pattern = "python",
  callback = function()
    local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
    local cr = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
    local macro = table.concat({
      esc,
      'gv"+y', -- reselect + yank to +
      esc,
      ":lua insert_py_log()", -- call the Lua inserter
      cr,
    })
    vim.fn.setreg("p", macro)
  end,
})
