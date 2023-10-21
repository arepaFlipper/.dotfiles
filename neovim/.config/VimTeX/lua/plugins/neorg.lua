return {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim"},
  config= function()
    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {}, -- Adds pretty icons to your files
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/notes",
            }
          }
        }
      }
    }
  end,
}
