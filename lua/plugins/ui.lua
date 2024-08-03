return {
	{
		"nvim-lua/plenary.nvim",
	},

	{
		"nvim-tree/nvim-web-devicons",
	},

	{
		"vhyrro/luarocks.nvim",
    	priority = 1001, -- this plugin needs to run before anything else
    	opts = {
    	    rocks = { "magick" },
    	},
	},

	{
		"3rd/image.nvim",
		dependencies = { "luarocks.nvim" },
		opts = require "plugins.configs.ui".image,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		init = require "plugins.configs.ui".telescope.init,
	},

	{
		"andrew-george/telescope-themes",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("themes")
		end
	},

	{
		"stevearc/dressing.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = require "plugins.configs.ui".dressing,
	},

	{
		"folke/which-key.nvim",
		cmd = "WhichKey",
		lazy = false,
		opts = require "plugins.configs.ui".which_key,
	},

	{
		"mrjones2014/legendary.nvim",
		priority = 10000,
		lazy = false,
		opts = require "plugins.configs.ui".legendary,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = { "s1n7ax/nvim-window-picker" },
		config = require "plugins.configs.ui".neo_tree.config,
	},

	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = require "plugins.configs.ui".bufferline.config,
	},

	{
		"Bekaboo/dropbar.nvim",
		dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
		config = require "plugins.configs.ui".dropbar.config,
	},

	{ -- Colored cursorline
		"mvllow/modes.nvim",
		opts = require "plugins.configs.ui".modes,
	},

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
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"akinsho/toggleterm.nvim",
		config = require "plugins.configs.ui".toggleterm.config,
	},

	-- Customize number column
	{
		"luukvbaal/statuscol.nvim",
		config = require "plugins.configs.ui".statuscol.config,
	},

	-- https://github.com/startup-nvim/startup.nvim/issues/51
	-- Start menu
	--{
	--	"startup-nvim/startup.nvim",
	--	config = require "plugins.configs.ui".startup.config,
	--},
}
