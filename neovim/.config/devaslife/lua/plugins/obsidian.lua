return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- keys = { "<leader>m", "<leader>j", "<leader>s" },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    workspaces = {
      {
        name = "general_vault",
        path = "~/Documents/obsidian_vault",
      }
    }
  }
}
