return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- keys = { "<leader>m", "<leader>j", "<leader>s" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      {
        name = "general_vault",
        path = "~/iPad_sync/obsidian_vault",
      },
    },
    daily_notes = {
      folder = "2-Areas/Journalist/Daily",
      date_format = "%Y_%m_%d",
      alias_format = "%A, %dth %B, %Y",
    },
    mappings = {
      ["gd"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["gi"] = {
        action = function()
          vim.cmd("ObsidianBacklinks")
        end,
        opts = { buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<leader>odl"] = {
        action = function()
          vim.cmd("ObsidianToday")
        end,
        opts = { buffer = true },
      },
      ["<leader>oo"] = {
        action = function()
          vim.cmd("ObsidianOpen")
        end,
        opts = { buffer = true },
      },
    },
    templates = {
      subdir = "Templates",
      date_format = "YYYY_MM_DD",
    },
    note_id_func = function(title)
      local suffix = ""
      if title ~= nil then
        suffix = title:gsub(" ", "-"):gsub("[^a-zA-Z0-9-]", ""):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. "-" .. suffix
    end,
  },
}
