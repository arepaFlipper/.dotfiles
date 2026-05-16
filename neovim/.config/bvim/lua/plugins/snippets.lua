return {
  -- { "saadparwaiz1/cmp_luasnip" },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("cmp").setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        sources = {
          { name = "luasnip" },
          -- more sources
        },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    build = "make install_jsregexp",
    keys = {
      {
        "<a-p>",
        function()
          local ls = require("luasnip")
          if ls.expand_or_jumpable() then
            ls.expand()
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip expand",
      },
      {
        "<a-J>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(1) then
            ls.jump(1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip jump next",
      },
      {
        "<a-K>",
        function()
          local ls = require("luasnip")
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip jump prev",
      },
      {
        "<a-L>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(1)
          else
            -- print current time
            local t = os.date("*t")
            local time = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
            print(time)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip next choice",
      },
      {
        "<a-H>",
        function()
          local ls = require("luasnip")
          if ls.choice_active() then
            ls.change_choice(-1)
          end
        end,
        mode = { "i", "s" },
        desc = "LuaSnip prev choice",
      },
      {
        "<Leader><CR>",
        "<cmd>LuaSnipEdit<cr>",
        mode = "n",
        desc = "Edit Snippets",
      },
    },
    config = function()
      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      ls.config.setup({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        store_selection_keys = "<A-p>",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "●", "GruvboxOrange" } },
            },
          },
        },
      })

      -- Load custom snippets
      require("luasnip.loaders.from_lua").load({ paths = { "~/.dotfiles/neovim/.config/snippets_lua/" } })
      require("luasnip.loaders.from_vscode").lazy_load()

      vim.api.nvim_create_user_command("LuaSnipEdit", function()
        require("luasnip.loaders.from_lua").edit_snippet_files()
      end, {})

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*/snippets/*.lua",
        callback = function()
          vim.keymap.set(
            "n",
            "<CR>",
            "/-- End Refactoring --<CR>O<Esc>O",
            { silent = true, buffer = true, desc = "Add new snippet above Refactoring line" }
          )
        end,
      })
    end,
  },
}
