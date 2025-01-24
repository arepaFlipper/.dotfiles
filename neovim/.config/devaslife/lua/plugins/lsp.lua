return {
  {
    "williamboman/mason.nvim",
    opts = {
      servers = {
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
      },
      setup = {
        tailwindcss = function(_, opts)
          local tw = LazyVim.lsp.get_raw_config("tailwindcss")
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Additional settings for Phoenix projects
          opts.settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          }

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})

          local format_kinds = opts.formatting.format
          opts.formatting.format = function(entry, item)
            format_kinds(entry, item) -- add icons
            return require("tailwindcss-colorizer-cmp").formatter(entry, item)
          end
        end,
      },
    },
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
        filetypes = { "solidity" },
        settings = {
          -- example of global remapping
          solidity = {
            includePath = "",
            remapping = { ["@OpenZeppelin/"] = "OpenZeppelin/openzeppelin-contracts@4.6.0/" },
            -- Array of paths to pass as --allow-paths to solc
            allowPaths = {},
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
