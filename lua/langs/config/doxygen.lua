return {
	plugins = {
		{
			"ef3d0c3e/doxyvim",
			opts = {},
		},

		-- Generate doxygen templates upon `:Neogen`
		{
			"https://github.com/danymat/neogen",
			config = function()
				require('neogen').setup({
					snippet_engine = "nvim" })
			end
		},
	}
}
