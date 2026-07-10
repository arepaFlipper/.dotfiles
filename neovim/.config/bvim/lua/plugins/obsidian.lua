vim.api.nvim_set_keymap("n", "<leader>odl", "<CMD>ObsidianToday<CR>", { noremap = true })
return {
  -- "obsidian-nvim/obsidian.nvim",
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
        path = "~/sync_repo/brain",
      },
    },
    daily_notes = {
      folder = "2-Areas/Journalist/Daily",
      date_format = "V-%Y_%m_%d",
      alias_format = "%A, %dth %B, %Y",
      default_tags = { "daily-notes" },
      template = "Templates/Daily Template.md",
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
      ["<leader>oo"] = {
        action = function()
          -- Open the current note in Obsidian at the line the cursor is on.
          -- Requires the "Advanced URI" community plugin in Obsidian, which
          -- supports the `line` parameter; the plain `obsidian://open` URI
          -- (used by :ObsidianOpen) cannot jump to a line.
          local vault_name = "brain"
          local vault_path = vim.fn.expand("~/sync_repo/brain")
          local filepath = vim.fn.expand("%:p")
          local line = vim.api.nvim_win_get_cursor(0)[1]

          if filepath:sub(1, #vault_path) == vault_path then
            local rel = filepath:sub(#vault_path + 2)
            local uri = string.format(
              "obsidian://advanced-uri?vault=%s&filepath=%s&line=%d",
              vim.uri_encode(vault_name),
              vim.uri_encode(rel),
              line
            )
            vim.ui.open(uri)
          else
            -- Fall back for notes outside the configured vault.
            vim.cmd("ObsidianOpen")
          end
        end,
        opts = { buffer = true },
      },
    },
    notes_subdir = "0-Inbox",
    new_notes_location = "notes_subdir",
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
