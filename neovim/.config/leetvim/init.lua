-- 1. Load LazyVim and set leader
require("config.lazy")
vim.g.mapleader = " "

-- 2. Helpers: emojis & colors
local emojis = dofile(vim.fn.expand("~/.dotfiles/neovim/.config/snippets_lua/emojis.lua")).Emojis
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
