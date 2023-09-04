return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local on_attach = require("neoconf.plugins.lspconfig").on_attach
      local capabilities = require("neoconf.plugins.lspconfig").capabilities
      local lspconfig = require("lspconfig")
      local util = require("lspconfig/util")
      local mason_lspconfig = require("mason-lspconfig")

      lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "rust" },
        root_dir = util.root_pattern("Cargo.toml"),
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
          },
        },
      })
      mason_lspconfig.setup({
        ensure_installed = { "rust_analyzer" },
      })
      print(lspconfig.rust_analyzer)
    end,
    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
      local on_attach = require("neoconf.plugins.lspconfig").on_attach
      local capabilities = require("neoconf.plugins.lspconfig").capabilities
      local options = {
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
        },
      }
      return options
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
}
