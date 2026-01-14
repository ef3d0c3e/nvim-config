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
		config = function()
			require "noice".setup {

			}
		end
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
		"miikanissi/modus-themes.nvim",
		priority = 1000,
		config = function()
			require "modus-themes".setup {
				transparent = true,
			}
		end
	},
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
		opts = {},
	},
	-- }}}

	-- {{{ Floating, per-split statusline
	{
		"b0o/incline.nvim",
		config = function()
			local helpers = require 'incline.helpers'
			local navic = require 'nvim-navic'
			local devicons = require 'nvim-web-devicons'

			local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			vim.api.nvim_set_hl(0, "BufferLineDiff_removed", { bg = "#2f2f39", fg = "#af4a5f" })
			vim.api.nvim_set_hl(0, "BufferLineDiff_changed", { bg = "#2f2f39", fg = "#2f9abf" })
			vim.api.nvim_set_hl(0, "BufferLineDiff_added", { bg = "#2f2f39", fg = "#2fba8f" })
			vim.api.nvim_set_hl(0, "BufferLineDiffSep", { bg = "None", fg = "#2f2f39" })

			require('incline').setup {
				window = {
					padding = 0,
					margin = { horizontal = 0, vertical = 0 },
				},
				render = function(props)
					local function get_git_diff()
						local icons = { removed = ' ', changed = ' ', added = ' ' }
						local signs = vim.b[props.buf].gitsigns_status_dict
						local labels = {}
						if signs == nil then
							return labels
						end
						for name, icon in pairs(icons) do
							if tonumber(signs[name]) and signs[name] > 0 then
								if #labels ~= 0 then
									table.insert(labels, { " ", group = 'BufferLineDiff_added' })
								end
								table.insert(labels, { icon .. signs[name], group = 'BufferLineDiff_' .. name })
							end
						end
						if #labels > 0 then
							table.insert(labels, { '', group = 'BufferLineDiffSep' })
						end
						return labels
					end

					local function get_diagnostic_label()
						local icons = { error = ' ', warn = ' ', info = ' ', hint = '󰌵 ' }
						local label = {}

						for severity, icon in pairs(icons) do
							local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
							if n > 0 then
								table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
							end
						end
						if #label > 0 then
							table.insert(label, { '┊ ' })
						end
						return label
					end

					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
					if filename == '' then
						filename = '[No Name]'
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					local res = {
						{ get_diagnostic_label() },
						{ get_git_diff() },
						ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or '',
						' ',
						{ filename, gui = 'bold' },
						modified and { "●", guifg = "#4f9fdf" } or { "" },
						guibg = '#44406e',
					}
					if props.focused then
						for _, item in ipairs(navic.get_data(props.buf) or {}) do
							table.insert(res, {
								{ ' > ', group = 'NavicSeparator' },
								{ item.icon, group = 'NavicIcons' .. item.type },
								{ item.name, group = 'NavicText' },
							})
						end
					end
					table.insert(res, ' ')
					return res
				end,
			}

		end,
		-- Optional: Lazy load Incline
		event = 'VeryLazy',
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
