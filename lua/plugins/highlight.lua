return {
	{
		"nvim-treesitter/nvim-treesitter",
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		config = require "plugins.configs.highlight".treesitter.config,
	},

	{
		"NvChad/nvim-colorizer.lua",
		opts = require "plugins.configs.highlight".colorizer,
	},
}
