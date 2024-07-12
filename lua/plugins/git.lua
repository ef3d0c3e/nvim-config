return {
	{
		"lewis6991/gitsigns.nvim",
		opts = require("plugins.configs.git").gitsigns,
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = require("plugins.configs.git").neogit,
	},
}
