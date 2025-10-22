return {
	{
		"nvim-tree/nvim-web-devicons",
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		init = require "plugins.configs.ui".telescope.init,
	},

	{
		"folke/which-key.nvim",
		cmd = "WhichKey",
		lazy = false,
		opts = require "plugins.configs.ui".which_key,
	},

	-- File/buffer/git explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = { "s1n7ax/nvim-window-picker" },
		config = require "plugins.configs.ui".neo_tree.config,
	},

	-- Changes vim tab bar
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require "plugins.configs.ui".bufferline.config,
	},

	{ -- Colored cursorline
		"mvllow/modes.nvim",
		opts = require "plugins.configs.ui".modes,
	},
	
	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require "plugins.configs.ui".lualine.config,
	},

	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")
			notify.setup({})
			vim.notify = notify
		end,
	},

	{
		"folke/noice.nvim",
		opts = require "plugins.configs.ui".noice,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = require "plugins.configs.ui".noice.config,
	},

	-- Navigate diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	-- Customize number column
	{
		"luukvbaal/statuscol.nvim",
		config = require "plugins.configs.ui".statuscol.config,
	},

	-- Split manager
	{
		"https://github.com/mrjones2014/smart-splits.nvim",
		config = require "plugins.configs.ui".smart_splits.config,
	},

	-- Custom splits borders
	{
		"https://github.com/nvim-zh/colorful-winsep.nvim",
		config = require "plugins.configs.ui".winsep.config,
	},

	-- Startup screen (for neovide only)
	{
	  'nvimdev/dashboard-nvim',
	  event = 'VimEnter',
	  lazy = true,
	  enabled = function()
		  return vim.g.neovide
	  end,
	  dependencies = { {'nvim-tree/nvim-web-devicons'}}
	},

	-- Manage settings
	{
		"folke/neoconf.nvim",
		init = require "plugins.configs.ui".neoconf.init,
	},

	--{
	--	"https://github.com/ef3d0c3e/nvim-clipboard",
	--	config = function ()
	--		require('nvim-clipboard').setup({
	--			max_items = 10,                                          -- Max clipboard history items
	--			file = vim.fn.stdpath("data") .. '/clipboard.txt',             -- Clipboard history file
	--			vault_file = vim.fn.stdpath('data') .. '/vault.dat'     -- Vault file location (optional)
	--		})
	--	end
	--},
}
