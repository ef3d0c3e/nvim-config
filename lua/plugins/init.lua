require("lazy").setup({
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	require "plugins.colors",
	require "plugins.ui",
	require "plugins.highlight",
	require "plugins.writing",
	require "plugins.git",
	--require "plugins.java",
	require "plugins.lsp",
})

require "plugins.keybinds"
