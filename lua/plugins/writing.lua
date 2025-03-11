return {
	--{
	--	"HiPhish/rainbow-delimiters.nvim",
	--	dependencies = {
	--		{
	--			"nvim-treesitter/nvim-treesitter",
	--		},
	--	},
	--	lazy = false,
	--	--event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	--	init = require "plugins.configs.writing".rainbow.init,
	--},

	--{
	--	"shellRaining/hlchunk.nvim",
	--	event = { "BufReadPre", "BufNewFile" },
	--	config = require "plugins.configs.writing".hlchunk.config
	--},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = require "plugins.configs.writing".surround
	},

	{
		"brenton-leighton/multiple-cursors.nvim",
		version = "*",	-- Use the latest tagged version
		opts = {},	-- This causes the plugin setup function to be called
		keys = {
			{"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}},
			{"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i", "x"}},
			{"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "x"}},
			{"<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i", "x"}},
			{"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}},
			{"<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = {"n", "x"}},
		},
	},

	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},

	{
		"Galac512/vim-aesenc",
		lazy = false,
	},

	-- Use treesitter to close and rename matching <tags>
	{
		"windwp/nvim-ts-autotag",
		config = require "plugins.configs.writing".autotag.config,
	},

	-- Auto align
	{
		"tommcdo/vim-lion",
		config = function () end,
	},

	-- Auto pair
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6", --recommended as each new version will have breaking changes
		config = require "plugins.configs.writing".ultimate_autopair.config,
	},

	-- Preview markdown in browser
	{
		"https://github.com/iamcco/markdown-preview.nvim",
	},
	
	-- Project-wide search & replace
	{
		"https://github.com/nvim-pack/nvim-spectre"
	},

	{
		"https://github.com/ray-x/sad.nvim",
		dependencies = { "https://github.com/ray-x/guihua.lua" },
		config = require "plugins.configs.writing".sad.config,
	},

	{
		"https://github.com/cshuaimin/ssr.nvim",
		config = require "plugins.configs.writing".ssr.config,
	},

	-- MD Preview
	{
		'brianhuster/live-preview.nvim',
		dependencies = {
			-- You can choose one of the following pickers
			'nvim-telescope/telescope.nvim',
			'ibhagwan/fzf-lua',
			'echasnovski/mini.pick',
		},
	},
}
