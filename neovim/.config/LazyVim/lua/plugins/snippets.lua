return {
  { "rafamadriz/friendly-snippets" },
  { "saadparwaiz1/cmp_luasnip" },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    keys = function()
      local ls = require("luasnip") --{{{

      -- require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").load({ paths = { "~/.config/snippets/" } })
      require("luasnip").config.setup({ store_selection_keys = "<A-p>" })

      -- javascript and react snippets
      ls.snippets = {
        html = {},
      }
      ls.snippets.javascript = ls.snippets.html
      ls.snippets.javascriptreact = ls.snippets.html
      ls.snippets.typescriptreact = ls.snippets.html

      require("luasnip/loaders/from_vscode").load({ include = { "html" } })
      require("luasnip/loaders/from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").load({ paths = { "~/.dotfiles/neovim/.config/snippets_lua/" } })

      vim.cmd([[command! LuaSnipEdit :lua require("luasnip.loaders.from_lua").edit_snippet_files()]]) --}}}

      -- Virtual Text{{{
      local types = require("luasnip.util.types")
      ls.config.set_config({
        history = true, --keep around last snippet local to jump back
        updateevents = "TextChanged,TextChangedI", --update changes as you type
        enable_autosnippets = true,
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "●", "GruvboxOrange" } },
            },
          },
          -- [types.insertNode] = {
          -- 	active = {
          -- 		virt_text = { { "●", "GruvboxBlue" } },
          -- 	},
          -- },
        },
      }) --}}}

      -- Key Mapping --{{{

      vim.keymap.set({ "i", "s" }, "<c-s>", "<Esc>:w<cr>")
      vim.keymap.set({ "i", "s" }, "<c-u>", '<cmd>lua require("luasnip.extras.select_choice")()<cr><C-c><C-c>')

      vim.keymap.set({ "i", "s" }, "<a-p>", function()
        if ls.expand_or_jumpable() then
          ls.expand()
        end
      end, { silent = true })
      -- vim.keymap.set({ "i", "s" }, "<C-k>", function()
      -- 	if ls.expand_or_jumpable() then
      -- 		ls.expand_or_jump()
      -- 	end
      -- end, { silent = true })
      -- vim.keymap.set({ "i", "s" }, "<C-j>", function()
      -- 	if ls.jumpable() then
      -- 		ls.jump(-1)
      -- 	end
      -- end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<A-y>", "<Esc>o", { silent = true })

      vim.keymap.set({ "i", "s" }, "<a-J>", function()
        if ls.jumpable(1) then
          ls.jump(1)
        end
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<a-K>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<a-L>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        else
          -- print current time
          local t = os.date("*t")
          local time = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
          print(time)
        end
      end)
      vim.keymap.set({ "i", "s" }, "<a-H>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end) --}}}

      -- More Settings --

      vim.keymap.set("n", "<Leader><CR>", "<cmd>LuaSnipEdit<cr>", { silent = true, noremap = true })
      vim.cmd([[autocmd BufEnter */snippets/*.lua nnoremap <silent> <buffer> <CR> /-- End Refactoring --<CR>O<Esc>O]])
    end,
  },
}
