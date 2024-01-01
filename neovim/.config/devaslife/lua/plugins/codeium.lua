return {
  "Exafunction/codeium.vim",
  config = function()
    -- Chang<c-g>e '<C-g>' here to any keycode you like.
    -- vim.g.codeium_no_map_tab = true
    --
    --- execute at the en end of the file only
    --- execute at the en end of the file only

    vim.keymap.set("i", "<tab>", function()
      local col = vim.fn.col(".")
      local line_len = vim.fn.col("$")
      if col ~= line_len then
        return vim.fn["codeium#Accept"]()
      else
        return vim.fn["<right>"]()
      end
    end, { expr = true })
    vim.keymap.set("i", "<right>", function()
      local col = vim.fn.col(".")
      local line_len = vim.fn.col("$")
      if col == line_len then
        return vim.fn["codeium#Accept"]()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, true, true), "n", true)
      end
    end, { expr = true })
    vim.keymap.set("i", "<c-;>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true })
    vim.keymap.set("i", "<c-,>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true })
    vim.keymap.set("i", "<c-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true })
  end,
}
