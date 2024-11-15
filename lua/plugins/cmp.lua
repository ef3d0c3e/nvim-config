return {
	{
		"onsails/lspkind.nvim",
		config = require "plugins.configs.cmp".lspkind.config,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"ray-x/cmp-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"paopaol/cmp-doxygen",
			"f3fora/cmp-spell",
			"f3fora/cmp-spell",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
		},
		config = require "plugins.configs.cmp".cmp.config,
	},

	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		config = require "plugins.configs.cmp".endhints.config,
	},
	---- Sets display location of inlay hints
	--{
	--	"felpafel/inlay-hint.nvim",
	--	event = "LspAttach",
	--	config = true,
	--},
}
