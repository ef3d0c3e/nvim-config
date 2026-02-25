return {
	init = function()
	end,

	plugins = {
		{
			"pablos123/shellcheck.nvim",
			config = function ()
				-- Pass extra arguments to the shellcheck command.
				require "shellcheck-nvim".setup {
					extras = { "-x", "--enable=all", },
				}
			end
		},
	},
}
