return {
	{ 'echasnovski/mini.colors', version = false },
	{"rktjmp/lush.nvim"},

	{
		--dir = "/home/baraquiel/.local/share/nvim/lazy/ppp/",
		"https://github.com/ef3d0c3e/nvim-ppp",
	},

	{
		"https://github.com/nyoom-engineering/oxocarbon.nvim",
		config = function()
			vim.cmd("colorscheme kanagawa")
			vim.cmd("hi Normal guibg=none")
		end,
	},

	{
		"https://github.com/rebelot/kanagawa.nvim",
		config = function()
		-- Default options:
			require('kanagawa').setup({
				compile = false,             -- enable compiling the colorscheme
				undercurl = true,            -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = true},
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,         -- do not set background color
				dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
				terminalColors = true,       -- define vim.g.terminal_color_{0,17}
				colors = {                   -- add/modify theme and palette colors
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors) -- add/modify highlights
					return {}
				end,
				theme = "wave",              -- Load "wave" theme when 'background' option is not set
				background = {               -- map the value of 'background' option to a theme
					dark = "wave",           -- try "dragon" !
					light = "lotus"
				},
			})
		end,
	}
}
