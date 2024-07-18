return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "cmake",
        "cpp",
        "css",
        "gitignore",
        "graphql",
        "prisma",
        "http",
        "rust",
        "scss",
        "sql",
        "query",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
   {
    "theHamsta/nvim_rocks",
    event = "VeryLazy",
    build = "pip3 install --user hererocks && python3 -mhererocks . -j2.1.0-beta3 -r3.0.0 && cp nvim_rocks.lua lua",
    config = function()
      ---- Add here the packages you want to make sure that they are installed
      --local nvim_rocks = require "nvim_rocks"
      --nvim_rocks.ensure_installed "uuid
    end,
  },
}
