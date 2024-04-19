return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "gopls",
        "rust-analyzer",
      })
      require("lvim.lsp.manager").setup("cssls", {
        settings = {
          css = {
            css = {
              validate = true,
              lint = { unknownAtRules = "ignore" },
            },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            gopls = { gofumpt = true },
          },
          flags = {
            debounce_text_changes = 150,
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              procMacro = { enable = true },
              cargo = { allFeatures = true },
              filetypes = { "rust", "rs" },
              autostart = true,
            },
          },
        },
      },
    },
  },
}
