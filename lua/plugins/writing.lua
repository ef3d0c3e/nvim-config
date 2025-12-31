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
		version = "*", -- Use the latest tagged version
		config = require "plugins.configs.writing".multiple_cursors.config,
		opts = {}, -- This causes the plugin setup function to be called
		keys = {
			{ "<C-j>",         "<Cmd>MultipleCursorsAddDown<CR>",        mode = { "n", "x" } },
			{ "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",        mode = { "n", "i", "x" } },
			{ "<C-k>",         "<Cmd>MultipleCursorsAddUp<CR>",          mode = { "n", "x" } },
			{ "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",          mode = { "n", "i", "x" } },
			{ "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
			{ "<Leader>a",     "<Cmd>MultipleCursorsAddMatches<CR>",     mode = { "n", "x" } },
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
		config = function() end,
	},

	-- Auto pairs
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = require "plugins.configs.writing".autopairs.config,
	},

	-- Treesitter-based search and replace
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

	-- Doc
	{
		"https://github.com/danymat/neogen",
		config = function()
			require('neogen').setup({ snippet_engine = "luasnip" })
		end
	},

	-- Norminette lint
	{
		"https://github.com/FtVim/norminette-lint.nvim",
		config = function()
			require("norminette-lint").setup({
				enable_on_start = false, -- Default to false to improve startup performance
				keybinding = "<leader>Fn", -- Default keybinding, you can define yours
			})
		end
	},

	--{
	--	"/home/user/code/sniper.nvim",
	--	dir = "/home/user/code/sniper.nvim/",
	--	dev = true,
	--	config = function ()
	--		local sniper = require("sniper")
	--		sniper.setup({
	--			marks =
	--			{
	--				paren =
	--				{
	--					hi = { bg = "#Ff2fFF", fg = "#000000", bold = true },
	--					key = { "p", "P" },
	--					symbols = { "(", ")", },
	--				},
	--				braces =
	--				{
	--					hi = { bg = "#Ff8f4F", fg = "#000000", bold = true },
	--					key = { "b", "B" },
	--					symbols = { "{", "}", },
	--				},
	--				commas =
	--				{
	--					hi = { bg = "#FFFF00", fg = "#000000", bold = true },
	--					key = { "c", "C" },
	--					symbols = { ",", ";", },
	--				}
	--			}
	--		})
	--		vim.keymap.set({"n", "v"}, "w", function ()
	--			sniper.mode.sniper_mode_enter(sniper)
	--		end)
	--	end
	--}
}
