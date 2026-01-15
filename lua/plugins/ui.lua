return {
	{
		"nvim-tree/nvim-web-devicons",
	},

	-- {{{ Snacks
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			explorer = { enabled = true },
			input = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			words = { enabled = true },
			styles = {
				notification = {
					-- wo = { wrap = true } -- Wrap notifications
				}
			},
			toggle = {
				map = vim.keymap.set, -- keymap.set function to use
				which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
				notify = true, -- show a notification when toggling
				-- icons for enabled/disabled states
				icon = {
					enabled = " ",
					disabled = " ",
				},
				-- colors for enabled/disabled states
				color = {
					enabled = "green",
					disabled = "yellow",
				},
				wk_desc = {
					enabled = "Disable ",
					disabled = "Enable ",
				}
			}
		},
		keys = {
			-- Other
			{ "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
			{ "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
			{ "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
			{ "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
		},
	},
	-- }}}

	-- {{{ Noice
	{
		"folke/noice.nvim",
		opts = {
			notify = { enabled = false },
			lsp = {
				hover = { enabled = false },
				signature = { enabled = false },
			},
		}
	},
	-- }}}

	{
		"folke/which-key.nvim",
		cmd = "WhichKey",
		priority = 900,
		lazy = false,
	},

	-- {{{ Theme
	{
		"https://github.com/serhez/teide.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require "teide".setup {
				transparent = false
			}
			vim.cmd("colorscheme teide-dark")
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#293038"})
			vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg= "#6272a4" })
			vim.api.nvim_set_hl(0, "SnacksPickerInputBorder", { fg= "#6272a4" })

		end
	},

	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup {
				exclude_filetypes = { "statusline", "heirline", "incline" },
				exclude_buftypes = { "nofile" },
			}
			require("nvim-highlight-colors").turnOff()
		end
	},
	-- }}}

	-- {{{ Floating, per-split statusline
	{
		"b0o/incline.nvim",
		event = 'VeryLazy',
		config = function() require "plugins.winbar" end,
	},
	-- }}}

	-- {{{ LSP breadcrumbs (required by incline)
	{
		"SmiteshP/nvim-navic",
		lazy = false,
		priority = 1000,
		config = function()
			require "nvim-navic".setup {}
		end,
	},
	-- }}}

	-- {{{ Indent guide
	{
		"saghen/blink.indent",
		config = function()
			require "blink.indent".setup {
			}
		end
	},
	-- }}}

	-- {{{ Buffer manager
	{
		"serhez/bento.nvim",
		opts = {},
	},
	-- }}}

	-- {{{ Statusline
	{
		"rebelot/heirline.nvim",
		config = function() require "plugins.statusline" end,
	},
	-- }}}

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require "gitsigns".setup {

			}
		end
	},

	-- {{{ Neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		config = function()
			require "neo-tree".setup {
				open_files_do_not_replace_types = { "terminal", "Trouble", "qf" },
				enable_git_status = true,
				enable_diagnostics = true,
			}
			vim.api.nvim_set_hl(0, "NeoTreeNormal", vim.api.nvim_get_hl(0, { name = "Normal" }))
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", vim.api.nvim_get_hl(0, { name = "Normal" }))
		end
	},
	-- }}}
}
