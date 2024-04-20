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
    end,
  },
  {
    "neovim/nvim-lspconfig",
    cssls = {
      setup = {
        filetypes = { "css", "scss", "sass" },
        lint = {
          unknownAtRules = "ignore",
        },
      },
    },
    opts = {
      servers = {
        cssls = {
          settings = {
            ["cssls"] = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
              filetypes = { "css", "scss", "sass" },
            },
          },
          lint = {
            unknownAtRules = "ignore",
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
