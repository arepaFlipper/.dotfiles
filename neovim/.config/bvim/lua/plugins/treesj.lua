return {
	"Wansmer/treesj",
	keys = { "<leader>m", "<leader>j", "<leader>s" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup({
			max_join_length = 550,
		})
	end,
}
