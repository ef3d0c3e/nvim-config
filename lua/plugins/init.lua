require("lazy").setup({
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	require "plugins.ui",
	require "plugins.writing",
	require "plugins.lsp",
})
