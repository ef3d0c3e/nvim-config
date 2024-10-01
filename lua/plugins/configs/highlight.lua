local config = {
	treesitter = {},

	colorizer = {
		filetypes = { "*" },
		user_default_options = {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = true, -- "Name" codes like Blue or blue
			RRGGBBAA = false, -- #RRGGBBAA hex codes
			AARRGGBB = false, -- 0xAARRGGBB hex codes
			rgb_fn = false, -- CSS rgb() and rgba() functions
			hsl_fn = false, -- CSS hsl() and hsla() functions
			css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
			css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			-- Available modes for `mode`: foreground, background,  virtualtext
			mode = "background", -- Set the display mode.
			-- Available methods are false / true / "normal" / "lsp" / "both"
			-- True is same as normal
			tailwind = "lsp", -- Enable tailwind colors
			-- parsers can contain values used in |user_default_options|
			sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
			virtualtext = "■",
			-- update color values even if buffer is not focused
			-- example use: cmp_menu, cmp_docs
			always_update = false
		},
		-- all the sub-options of filetypes apply to buftypes
		buftypes = {},
	},
}

function config.treesitter.config()
	--require("nvim-dap-repl-highlights").setup() -- Required to be set up before treesitter
	require("nvim-treesitter").setup({
		ensure_installed = {
			"lua",
			"vim",
			"vimdoc",
			"lua",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"c",
			"cpp",
			"markdown",
			"markdown_inline",
			"bash",
			"dap_repl",
		},

		highlight = {
			enable = true,
			use_languagetree = true,
		},

		indent = { enable = true },

		-- Settings for nvim-ts-autotag
		autotag = {
			enable = true,
			enable_rename = true,
			enable_close = true,
			enable_close_on_slash = true,
			filetypes = { "html" , "xml" },
		}
	})
end

return config
