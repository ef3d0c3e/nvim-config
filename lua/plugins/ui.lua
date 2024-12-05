return {
	--{
	--	"nvim-lua/plenary.nvim",
	--},

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
	},

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
}
