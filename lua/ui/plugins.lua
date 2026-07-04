return {
	{
		"ef3d0c3e/colr-icons",
		opts = {
			icons =
			{
				theme_selection = {
					"material",
					"catpuccin-frappe",
				},
			}
		},
	},

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = false,
			},
			input = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			picker = {
				enabled = true,
				layout = {
					preview = "main",
					preset = "ivy",
				},

			},
			quickfile = { enabled = true },
			scope = { enabled = true },
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
		},
	},

	{
		"https://github.com/folke/which-key.nvim",
		opts = {
			preset = "helix",
		},
	},

	{
		"rebelot/heirline.nvim",
		dependencies = { "lewis6991/gitsigns.nvim" },
		config = function()
			require "heirline".setup {
				statusline = require "ui.statusline",
				--statuscolumn = require "plugins.statuscol",
			}
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		config = require "ui.neo_tree".config
	},

	{
		"folke/noice.nvim",
		opts = {
			views = {
				cmdline_popup = {
					border = {
						style = "none",
						padding = { 1, 2 },
					},
					filter_options = {},
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
			},
			notify = { enabled = false },
			lsp = {
				progress = {
					enabled = true,
					-- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
					-- See the section on formatting for more details on how to customize.
					--- @type NoiceFormat|string
					format = "lsp_progress",
					--- @type NoiceFormat|string
					format_done = "lsp_progress_done",
					throttle = 1000 / 30, -- frequency to update lsp progress message
					view = "mini",
				},
				hover = { enabled = true },
				signature = { enabled = true },
			},
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		}
	},

	-- Buffers
	{
		"serhez/bento.nvim",
		opts = {},
	},
}
