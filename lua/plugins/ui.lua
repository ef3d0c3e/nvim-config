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
			-- LSP [TODO]
			{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
			{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
			{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
			{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
			{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
			-- Other
			{ "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
			{ "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
			{ "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
			{ "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
		},
	},
	-- }}}

	{
		"folke/which-key.nvim",
		cmd = "WhichKey",
		priority = 900,
		lazy = false,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
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
				transparent = true
			}
			vim.cmd("colorscheme teide-dark")
		end
	},
	-- }}}

	-- {{{ Floating, per-split statusline
	{
		"b0o/incline.nvim",
		config = function()
			local helpers = require 'incline.helpers'
			local navic = require 'nvim-navic'
			local devicons = require 'nvim-web-devicons'
			require('incline').setup {
				window = {
					padding = 0,
					margin = { horizontal = 0, vertical = 0 },
				},
				render = function(props)
					local function get_git_diff()
						local icons = { removed = '', changed = '', added = '' }
						local signs = vim.b[props.buf].gitsigns_status_dict
						local labels = {}
						if signs == nil then
							return labels
						end
						for name, icon in pairs(icons) do
							if tonumber(signs[name]) and signs[name] > 0 then
								table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
							end
						end
						if #labels > 0 then
							table.insert(labels, { '┊ ' })
						end
						return labels
					end

					local function get_diagnostic_label()
						local icons = { error = '', warn = '', info = '', hint = '' }
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
		"nvim-lualine/lualine.nvim",
		config = function()
			local function pill(component, color)
				return vim.tbl_extend("force", component, {
					separator = { left = "", right = "" },
					color = { fg = color, bg = "NONE" },
					padding = { left = 0, right = 0 },
				})
			end

			require "lualine".setup {
				options = {
					icons_enabled = true,
					theme = "auto",
					component_separators = "",
					section_separators = "",
					globalstatus = false, -- one bar per nvim instance
				},

				sections = {
					-- LEFT
					lualine_a = {
						{
							"mode",
							fmt = function(str) return " " .. str .. " " end,
						},
					},

					lualine_b = {
						{
							function()
								return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
							icon = "",
						},
						{
							"branch",
							icon = "",
						},
					},

					-- CENTER (INTENTIONALLY EMPTY)
					lualine_c = {},

					-- RIGHT
					lualine_x = {
						-- LSPs
						{
							function()
								local clients = {}
								for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
									table.insert(clients, client.name)
								end
								return table.concat(clients, ",")
							end,
							icon = "",
						},

						-- CR / CRLF
						{
							function()
								return vim.bo.fileformat:upper()
							end,
						},

						-- Encoding
						{
							function()
								return (vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding):upper()
							end,
						},

						-- Line:Col (+ Visual WxH)
						{
							function()
								local l, c = unpack(vim.api.nvim_win_get_cursor(0))
								local out = string.format("%d:%d", l, c)

								if vim.fn.mode():match("[vV\22]") then
									local v = vim.fn.getpos("v")
									local h = math.abs(v[2] - l) + 1
									local w = math.abs(v[3] - c) + 1
									out = out .. string.format(" (%dx%d)", w, h)
								end

								return out
							end,
						},

						-- Clock
						{
							function()
								return os.date("%H:%M")
							end,
							icon = "",
						},
					},

					lualine_y = {},
					lualine_z = {},
				},
			}
		end
	},
	-- }}}
}
