local config = {
	mason = {},
	blink = {},
	tiny_inline_diagnostic = {},
	fidget = {},
	actions_preview = {},
	lspui = {},
	lspkind = {},
	inlay_hints = {},
}


-- {{{ mason
function config.mason.config()
	-- Setup Mason
	require("mason").setup({
		registries = {
			'github:nvim-java/mason-registry',
			'github:mason-org/mason-registry',
		},
	})
end
-- }}}

-- {{{ blink
function config.blink.config()
	require "blink.cmp".setup {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-e: Hide menu
		-- C-k: Toggle signature help
		--
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = {
			preset = 'none',
			['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
			['<C-e>'] = { 'cancel', 'fallback' },

			['<Tab>'] = {
				function(cmp)
					if cmp.snippet_active() then
						return cmp.accept()
					else
						return cmp.select_and_accept()
					end
				end,
				'snippet_forward',
				'fallback',
			},
			['<S-Tab>'] = { 'snippet_backward', 'fallback' },

			['<Up>'] = { 'select_prev', 'fallback' },
			['<Down>'] = { 'select_next', 'fallback' },
			['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
			['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

			['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
			['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono'
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		-- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },

		completion = {
			-- 'prefix' will fuzzy match on the text before the cursor
			-- 'full' will fuzzy match on the text before _and_ after the cursor
			-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
			keyword = { range = 'full' },

			-- Disable auto brackets
			-- NOTE: some LSPs may add auto brackets themselves anyway
			accept = { auto_brackets = { enabled = false }, },

			-- Don't select by default, auto insert on selection
			list = { selection = { preselect = false, auto_insert = true } },
			-- or set via a function
			list = { selection = { preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end } },

			menu = {
				-- Don't automatically show the completion menu
				auto_show = true,

				-- nvim-cmp style menu
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
					},
				}
			},

			-- Show documentation when selecting a completion item
			documentation = { auto_show = true, auto_show_delay_ms = 500 },

			-- Display a preview of the selected item on the current line
			ghost_text = { enabled = true },
		},

		sources = {
			-- Remove 'buffer' if you don't want text completions, by default it's only enabled when LSP returns no items
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		-- Use a preset for snippets, check the snippets documentation for more information
		snippets = { preset = 'luasnip' },

		-- Experimental signature help support
		signature = { enabled = true }
	}
end

-- }}}

-- {{{ tiny_inline_diagnostic

function config.tiny_inline_diagnostic.config()
	require('tiny-inline-diagnostic').setup({
        show_all_diags_on_cursorline = true,
	})
end
-- }}}

-- {{{ fidget
function config.fidget.config()
	local fidget = require("fidget")
	fidget.setup(
		{
			-- Options related to LSP progress subsystem
			progress = {
				poll_rate = 0,  -- How and when to poll for progress messages
				suppress_on_insert = false, -- Suppress new messages while in insert mode
				ignore_done_already = false, -- Ignore new tasks that are already complete
				ignore_empty_message = false, -- Ignore new tasks that don't contain a message
				clear_on_detach = -- Clear notification group when LSP server detaches
					function(client_id)
						local client = vim.lsp.get_client_by_id(client_id)
						return client and client.name or nil
					end,
				notification_group = -- How to get a progress message's notification group key
					function(msg) return msg.lsp_client.name end,
				ignore = {}, -- List of LSP servers to ignore

				-- Options related to how LSP progress messages are displayed as notifications
				display = {
					render_limit = 16, -- How many LSP messages to show at once
					done_ttl = 3, -- How long a message should persist after completion
					done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
					done_style = "Constant", -- Highlight group for completed LSP tasks
					progress_ttl = math.huge, -- How long a message should persist when in progress
					progress_icon = -- Icon shown when LSP progress tasks are in progress
					{ pattern = "dots", period = 1 },
					progress_style = -- Highlight group for in-progress LSP tasks
					"WarningMsg",
					group_style = "Title", -- Highlight group for group name (LSP server name)
					icon_style = "Question", -- Highlight group for group icons
					priority = 30, -- Ordering priority for LSP notification group
					skip_history = true, -- Whether progress notifications should be omitted from history
					format_message = -- How to format a progress message
						require("fidget.progress.display").default_format_message,
					format_annote = -- How to format a progress annotation
						function(msg) return msg.title end,
					format_group_name = -- How to format a progress notification group's name
						function(group) return tostring(group) end,
					--overrides = {							 -- Override options from the default notification config
					--	rust_analyzer = { name = "rust-analyzer" },
					--},
				},

				-- Options related to Neovim's built-in LSP client
				lsp = {
					progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
				},
			},

			-- Options related to notification subsystem
			notification = {
				poll_rate = 10, -- How frequently to update and render notifications
				filter = vim.log.levels.INFO, -- Minimum notifications level
				history_size = 128, -- Number of removed messages to retain in history
				override_vim_notify = false, -- Automatically override vim.notify() with Fidget
				configs =       -- How to configure notification groups when instantiated
				{ default = require("fidget.notification").default_config },
				redirect =      -- Conditionally redirect notifications to another backend
					function(msg, level, opts)
						if opts and opts.on_open then
							return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
						end
					end,

				-- Options related to how notifications are rendered as text
				view = {
					stack_upwards = true, -- Display notification items from bottom to top
					icon_separator = " ", -- Separator between group name and icon
					group_separator = "---", -- Separator between notification groups
					group_separator_hl = -- Highlight group used for group separator
					"Comment",
				},

				-- Options related to the notification window and buffer
				window = {
					normal_hl = "Comment", -- Base highlight group in the notification window
					winblend = 100, -- Background color opacity in the notification window
					border = "none", -- Border around the notification window
					zindex = 45, -- Stacking priority of the notification window
					max_width = 0, -- Maximum width of the notification window
					max_height = 0, -- Maximum height of the notification window
					x_padding = 1, -- Padding from right edge of window boundary
					y_padding = 0, -- Padding from bottom edge of window boundary
					align = "bottom", -- How to align the notification window
					relative = "editor", -- What the notification window position is relative to
				},
			},

			-- Options related to integrating with other plugins
			integration = {
				["nvim-tree"] = {
					enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
				},
			},

			-- Options related to logging
			logger = {
				level = vim.log.levels.WARN, -- Minimum logging level
				float_precision = 0.01, -- Limit the number of decimals displayed for floats
				path =         -- Where Fidget writes its logs to
					string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
			},
		})
end

-- }}}

-- {{{ actions-preview
function config.actions_preview.config()
	local hl = require("actions-preview.highlight")
	require "actions-preview".setup({
		-- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
		diff = {
			ctxlen = 3,
		},

		-- priority list of preferred backend
		backend = { "telescope" },

		-- options related to telescope.nvim
		telescope = vim.tbl_extend(
			"force",
			-- telescope theme: https://github.com/nvim-telescope/telescope.nvim#themes
			{},
			require("telescope.themes"),
			--require("telescope.themes").get_dropdown(),
			-- a table for customizing content
			{
				-- a function to make a table containing the values to be displayed.
				-- fun(action: Action): { title: string, client_name: string|nil }
				make_value = nil,

				-- a function to make a function to be used in `display` of a entry.
				-- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
				-- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
				make_make_display = nil,
			}),

		-- TODO: Fix diff highlightinh
		highlight_command = {
			hl.delta(),
		},
	})
end

-- }}}

-- {{{ LspUI
function config.lspui.config()
	local lspui = require("LspUI").setup({
		lightbulb = {
			enable = false
		}
	})
end

-- }}}

-- {{{ lspkind
function config.lspkind.config()
	require('lspkind').init({
		-- DEPRECATED (use mode instead): enables text annotations
		--
		-- default: true
		-- with_text = true,

		-- defines how annotations are shown
		-- default: symbol
		-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
		mode = 'symbol_text',

		-- default symbol map
		-- can be either 'default' (requires nerd-fonts font) or
		-- 'codicons' for codicon preset (requires vscode-codicons font)
		--
		-- default: 'default'
		preset = 'default',

		-- override preset symbols
		--
		-- default: {}
		symbol_map = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			KeywordFunction = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Boolean = ' ',
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			Type = ' ',
			TypeParameter = '󰆩 ',
			VariableBuiltin = '󰫧 ',
			KeywordOperator = ' ',
			VariableMember = '󱃻 ',
			Comment = ' ',
			String = ' ',
			StringEscape = '󱊷 ',
			Character = '󰾹',
			Number = '',
			KeywordType = '',
			FunctionMacro = '󰡱',
			VariableParameter = ' ',
			KeywordConditional = '󰦐 ',
			KeywordModifier = ' ',
			KeywordImport = '󰋺 ',
			TypeBuiltin = '',
			KeywordRepeat = '󰑖',
			KeywordReturn = '󰌑',
			_Parent = '󱘎 ',
		},
	})
end
-- }}}

-- {{{ inlay_hints
function config.inlay_hints.config()
	require('inlay-hint').setup({
		-- Position of virtual text. Possible values:
		-- 'eol': right after eol character (default).
		-- 'right_align': display right aligned in the window.
		-- 'inline': display at the specified column, and shift the buffer
		-- text to the right as needed.
		virt_text_pos = 'eol',
		-- Can be supplied either as a string or as an integer,
		-- the latter which can be obtained using |nvim_get_hl_id_by_name()|.
		highlight_group = 'LspInlayHint',
		-- Control how highlights are combined with the
		-- highlights of the text.
		-- 'combine': combine with background text color. (default)
		-- 'replace': only show the virt_text color.
		hl_mode = 'combine',
		-- line_hints: array with all hints present in current line.
		-- options: table with this plugin configuration.
		-- bufnr: buffer id from where the hints come from.
		display_callback = function(line_hints, options, bufnr)
			if options.virt_text_pos == 'inline' then
				local lhint = {}
				for _, hint in pairs(line_hints) do
					local text = ''
					local label = hint.label
					if type(label) == 'string' then
						text = label
					else
						for _, part in ipairs(label) do
							text = text .. part.value
						end
					end
					if hint.paddingLeft then
						text = ' ' .. text
					end
					if hint.paddingRight then
						text = text .. ' '
					end
					lhint[#lhint + 1] = { text = text, col = hint.position.character }
				end
				return lhint
			elseif options.virt_text_pos == 'eol' or options.virt_text_pos == 'right_align' then
				local k1 = {}
				local k2 = {}
				table.sort(line_hints, function(a, b)
					return a.position.character < b.position.character
				end)
				for _, hint in pairs(line_hints) do
					local label = hint.label
					local kind = hint.kind
					local node = kind == 1
					and vim.treesitter.get_node({
						bufnr = bufnr,
						pos = {
							hint.position.line,
							hint.position.character - 1,
						},
					})
					or nil
					local node_text = node and vim.treesitter.get_node_text(node, bufnr, {}) or ''
					local text = ''
					if type(label) == 'string' then
						text = label
					else
						for _, part in ipairs(label) do
							text = text .. part.value
						end
					end
					if kind == 1 then
						k1[#k1 + 1] = text:gsub(':%s*', node_text .. ': ')
					else
						k2[#k2 + 1] = text:gsub(':$', '')
					end
				end
				local text = ''
				if #k2 > 0 then
					text = '<- (' .. table.concat(k2, ',') .. ')'
				end
				if #text > 0 then
					text = text .. ' '
				end
				if #k1 > 0 then
					text = text .. '=> ' .. table.concat(k1, ', ')
				end

				return text
			end
			return nil
		end,
	})
end
-- }}}

return config
