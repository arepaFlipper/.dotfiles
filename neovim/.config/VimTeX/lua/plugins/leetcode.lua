return {
  "Dhanus3133/LeetBuddy.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("leetbuddy").setup({
      language = "cpp",
    })
  end,
  keys = {
    { "ñl", "<cmd>LBQuestions<cr>", desc = "List Questions" },
    { "ñq", "<cmd>LBQuestion<cr>", desc = "View Question" },
    { "ñr", "<cmd>LBReset<cr>", desc = "Reset Code" },
    { "ñt", "<cmd>LBTest<cr>", desc = "Run Code" },
    { "ñs", "<cmd>LBSubmit<cr>", desc = "Submit Code" },
    { "ñp", "<cmd>LBChangeLanguage<cr>", desc = "switch language" },
  },
}
