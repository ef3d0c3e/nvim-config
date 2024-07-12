return {

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"ray-x/cmp-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"paopaol/cmp-doxygen",
		},
		config = require "plugins.configs.cmp".cmp.config,
	},
}
