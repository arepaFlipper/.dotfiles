local Util = require("lazyvim.util")

return {
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {},
      hsl_color = {
        pattern = "hsl%(%d+,? %d+,? %d+%)",
        group = function(_, match)
          local utils = require("solarized-osaka.hsl")
          local h, s, l = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
          h, s, l = tonumber(h), tonumber(s), tonumber(l)
          ---@diagnostic disable-next-line: param-type-mismatch
          local hex_color = utils.hslToHex(h, s, l)
          return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
        end,
      },
    },
  },
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        -- open blame window
        blame = "<Leader>gb",
        -- open file/folder in git repository
        browse = "<Leader>go",
      },
    },
  },
  {
    "telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      -- { "<leader><space>", Util.telescope("files", { cwd = false }), desc = "Find Files (root dir)" },
      -- { "<leader>/", Util.telescope("live_grep", { cwd = false }), desc = "Find Files (root dir)" },
      {
        "<Leader>fP",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "ñf",
        function()
          local builtin = require("telescope.buildin")
          builtin.live_grep()
        end,
        desc =
        "Search for a string in your current working directory and get results live as you type, respects .gitignore",
      },
      {
        "ño",
        function()
          local builtin = require("telescope.builtin")
          builtin.buffers()
        end,
        desc = "Lists open buffers",
      },
      {
        "ñt",
        function()
          local builtin = require("telescope.builtin")
          builtin.help_tags()
        end,
      },
      {
        "ññ",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        "ñe",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Lists Diagnostics for all open buffers or a specific buffer",
      },
      {
        "ñs",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
        desc = "Lists Function names, variables, from Treesitter",
      },
      { "<leader><space>", Util.pick("files", { cwd = nil }),     desc = "Find Files (root dir)" },
      { "<leader>/",       Util.pick("live_grep", { cwd = nil }), desc = "Find Files (root dir)" },
      {
        "sf",
        function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = { n = {} },
      })
      opts.picker = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope-file-browser in its place
          hijack_netrw = true,
          mappings = {
            -- your custom insert mode mappings
            ["n"] = {
              --your custom normal mode mappings
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinser")
              end,
              ["<C-u>"] = function(prompt_bufnr)
                for _ = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for _ = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}
