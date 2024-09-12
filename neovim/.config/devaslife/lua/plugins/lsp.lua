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
        "solidity-ls",
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
    solidity_ls = {
      setup = {
        filetypes = {"solidity"},
        settings = {
        -- example of global remapping
          solidity = {
              includePath = '',
              remapping = { ["@OpenZeppelin/"] = 'OpenZeppelin/openzeppelin-contracts@4.6.0/' },
              -- Array of paths to pass as --allow-paths to solc
              allowPaths = {}
          },
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
