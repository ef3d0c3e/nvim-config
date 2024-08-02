return {
	{ 'echasnovski/mini.colors', version = false },
	{"rktjmp/lush.nvim"},

	{
		--dir = "/home/baraquiel/.local/share/nvim/lazy/ppp/",
		"https://git.pundalik.org/ef3d0c3e/nvim-ppp",
		--config = function()
		--	vim.cmd("colorscheme ppp")
		--end,
	},

	{
		"https://github.com/nyoom-engineering/oxocarbon.nvim",
		config = function()
			vim.cmd("colorscheme oxocarbon")
		end,
	},
}
