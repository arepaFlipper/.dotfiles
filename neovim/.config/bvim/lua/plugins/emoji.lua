return {
  "allaman/emoji.nvim",
  version = "1.0.0", -- Pin to a stable version
  ft = { "markdown", "gitcommit", "COMMIT_EDITMSG" },
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required dependency
    "nvim-telescope/telescope.nvim", -- Optional for telescope integration
    {
      "saghen/blink.cmp", -- Required for completion integration
      dependencies = { "saghen/blink.compat" },
      opts = {
        sources = {
          default = { "emoji" },
          providers = {
            emoji = {
              name = "emoji",
              module = "blink.compat.source",
              transform_items = function(ctx, items)
                local kind = require("blink.cmp.types").CompletionItemKind.Text
                for i = 1, #items do
                  items[i].kind = kind
                end
                return items
              end,
            },
          },
        },
      },
    },
  },
  opts = {
    enable_cmp_integration = true, -- Needed for blink.cmp integration
  },
  config = function(_, opts)
    require("emoji").setup(opts)

    -- Telescope integration (optional)
    local ts = require("telescope").load_extension("emoji")
    vim.keymap.set("n", "<leader>se", ts.emoji, { desc = "[S]earch [E]moji" })
  end,
}
