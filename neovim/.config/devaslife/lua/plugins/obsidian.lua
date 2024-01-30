return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- keys = { "<leader>m", "<leader>j", "<leader>s" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      {
        name = "general_vault",
        path = "~/Documents/obsidian_vault",
        overrides = {
          notes_subdit = "inbox",
        }
      },
    },
    daily_notes = {
      folder = "Journalist/Daily",
      date_format = "%Y_%m_%d",
      new_note_title = "New Note: ${slug}",
    },
    mappings = {
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      ["<leader>dl"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    note_id_func = function(title)
      local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^a-zA-Z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.time()) .. "-" .. suffix
      end
    end,
  }
}
