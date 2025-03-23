return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      -- configuration goes here
      lang = "python3",
      storage = {
        home = vim.loop.os_homedir() .. "/Documents/yt-tutos/neetcode/leetcoding",
        cache = vim.loop.os_homedir() .. "/Documents/yt-tutos/neetcode/leetcoding/cache",
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
        "codelldb",
        "rust-analyzer",
      },
    },
  },
  { "mfussenegger/nvim-dap" },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
    keys = {
      { "ñdb", "<cmd>DapToggleBreakpoint<CR>", desc = "Add breakpoint at line", remap = true },
      { "ñdr", "<cmd>DapContinue<CR>", desc = "Start or continue the debugger" },
      { "ñdn", "<cmd>DapStepOver<CR>", desc = "Start or continue the debugger" },
      { "<C-'>", "<cmd>DapStepOver<CR>", desc = "Start or continue the debugger" },
      { "ñdo", "<cmd>DapStepOut<CR>", desc = "Reset Code" },
      { "ñdi", "<cmd>StepInto<CR>", desc = "Run Code" },
      { "ñs", "<cmd>LBSubmit<CR>", desc = "Submit Code" },
      { "ñp", "<cmd>LBChangeLanguage<CR>", desc = "switch language" },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  { "LazyVim/LazyVim", version = "v13.9.1" },
}
