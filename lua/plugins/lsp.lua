return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = require "plugins.configs.lsp".lspconfig.config,
	},

	{
		"nvimtools/none-ls.nvim",
	},

	{
		"ef3d0c3e/nml-nvim"
	},

	-- LSP indexing status
	{
		"j-hui/fidget.nvim",
		event = "VimEnter",
		config = require "plugins.configs.lsp".fidget.config,
	},

	{
		"aznhe21/actions-preview.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = require "plugins.configs.lsp".actions_preview.config,
	},

	{
		"jinzhongjia/LspUI.nvim",
		branch = "main",
		config = require "plugins.configs.lsp".lspui.config,
	},

	-- Auto setup lua_ls for neovim plugin developpement (also a requirement of nvim-dap-ui)
	{
		"folke/neodev.nvim",
		config = require "plugins.configs.lsp".neodev.config,
	},

	-- Ltex-ls integration
	--{
	--	"barreiroleo/ltex_extra.nvim",
	--	ft = { "markdown", "tex" },
	--	dependencies = { "neovim/nvim-lspconfig" },
	--	config = require "plugins.configs.lsp".ltex.config,
	--},
}
