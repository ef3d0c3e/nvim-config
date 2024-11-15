local config = {
	lspconfig = {},
	ccls = {},
	fidget = {},
	actions_preview = {},
	lspui = {},
	neodev = {},
	ltex = {},
}

local ccls_filetypes = { "c", "cpp", "objc", "objcpp", "opencl" }

function get_capabilities()
	local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true
	}

	return capabilities
end

-- {{{ lspconfig
function config.lspconfig.config()
	-- Setup Mason
	require("mason").setup({
		ensure_installed = { "lua_ls", "ltex-ls", "html" },
	})
	require("mason-lspconfig").setup()

	local lspconfig = require("lspconfig")

	-- Diagnostics symbols for display in the sign column.
	local signs = { Error = "", Warn = "", Hint = "󰛨", Info = "" }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	local capabilities = get_capabilities()

	-- Servers using default config
	local servers = { "pylsp", "glslls", "clangd" }
	for _, lsp in ipairs(servers) do
		lspconfig[lsp].setup({
			capabilities = capabilities
		})
	end

	lspconfig.lua_ls.setup
	{
		cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lua-language-server" },
		settings =
		{
			Lua =
			{
				hint =
				{
					enable = true,
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = {
						[vim.fn.expand "$VIMRUNTIME/lua"] = true,
						[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
						[vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
						[vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
					},
					maxPreload = 100000,
					preloadFileSize = 10000,
				},
			},
		},
	}

	--lspconfig.ccls.setup
	--{
	--	cmd = { "ccls" },
	--	filetypes = ccls_filetypes,
	--	offset_encoding = "utf-16",

	--	init_options =
	--	{
	--		index =
	--		{
	--			threads = 0;
	--		};
	--		clang =
	--		{
	--			excludeArgs = { "-frounding-math" };
	--		};
	--		highlight = {
	--			lsRanges = true;
	--		};
	--	},
	--}

	lspconfig.cmake.setup
	{
		cmd = { "cmake-language-server" },

		initialization_options = {
			buildDirectory = "build",
		},
	}

	lspconfig.rust_analyzer.setup {
		cmd = { "rust-analyzer" },
		filetypes = { "rust" },
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
					disabled = {"unresolved-proc-macro"},
					enableExperimental = true,
				},
				procMacro = {
					ignored = {
						["auto_registry"] = {"auto_registry"}
					},
				},
			},
		},
	}
end
-- }}}

-- {{{ fidget
function config.fidget.config()
	local fidget = require("fidget")
	fidget.setup(
	{
	-- Options related to LSP progress subsystem
	progress = {
		poll_rate = 0,								-- How and when to poll for progress messages
		suppress_on_insert = false,	 -- Suppress new messages while in insert mode
		ignore_done_already = false,	-- Ignore new tasks that are already complete
		ignore_empty_message = false, -- Ignore new tasks that don't contain a message
		clear_on_detach =						 -- Clear notification group when LSP server detaches
			function(client_id)
				local client = vim.lsp.get_client_by_id(client_id)
				return client and client.name or nil
			end,
		notification_group =					-- How to get a progress message's notification group key
			function(msg) return msg.lsp_client.name end,
		ignore = {},									-- List of LSP servers to ignore

		-- Options related to how LSP progress messages are displayed as notifications
		display = {
			render_limit = 16,					-- How many LSP messages to show at once
			done_ttl = 3,							 -- How long a message should persist after completion
			done_icon = "✔",						-- Icon shown when all LSP progress tasks are complete
			done_style = "Constant",		-- Highlight group for completed LSP tasks
			progress_ttl = math.huge,	 -- How long a message should persist when in progress
			progress_icon =						 -- Icon shown when LSP progress tasks are in progress
				{ pattern = "dots", period = 1 },
			progress_style =						-- Highlight group for in-progress LSP tasks
				"WarningMsg",
			group_style = "Title",			-- Highlight group for group name (LSP server name)
			icon_style = "Question",		-- Highlight group for group icons
			priority = 30,							-- Ordering priority for LSP notification group
			skip_history = true,				-- Whether progress notifications should be omitted from history
			format_message =						-- How to format a progress message
				require("fidget.progress.display").default_format_message,
			format_annote =						 -- How to format a progress annotation
				function(msg) return msg.title end,
			format_group_name =				 -- How to format a progress notification group's name
				function(group) return tostring(group) end,
			--overrides = {							 -- Override options from the default notification config
			--	rust_analyzer = { name = "rust-analyzer" },
			--},
		},

		-- Options related to Neovim's built-in LSP client
		lsp = {
			progress_ringbuf_size = 0,	-- Configure the nvim's LSP progress ring buffer size
		},
	},

	-- Options related to notification subsystem
	notification = {
		poll_rate = 10,							 -- How frequently to update and render notifications
		filter = vim.log.levels.INFO, -- Minimum notifications level
		history_size = 128,					 -- Number of removed messages to retain in history
		override_vim_notify = false,	-- Automatically override vim.notify() with Fidget
		configs =										 -- How to configure notification groups when instantiated
			{ default = require("fidget.notification").default_config },
		redirect =										-- Conditionally redirect notifications to another backend
			function(msg, level, opts)
				if opts and opts.on_open then
					return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
				end
			end,

		-- Options related to how notifications are rendered as text
		view = {
			stack_upwards = true,			 -- Display notification items from bottom to top
			icon_separator = " ",			 -- Separator between group name and icon
			group_separator = "---",		-- Separator between notification groups
			group_separator_hl =				-- Highlight group used for group separator
				"Comment",
		},

		-- Options related to the notification window and buffer
		window = {
			normal_hl = "Comment",			-- Base highlight group in the notification window
			winblend = 100,						 -- Background color opacity in the notification window
			border = "none",						-- Border around the notification window
			zindex = 45,								-- Stacking priority of the notification window
			max_width = 0,							-- Maximum width of the notification window
			max_height = 0,						 -- Maximum height of the notification window
			x_padding = 1,							-- Padding from right edge of window boundary
			y_padding = 0,							-- Padding from bottom edge of window boundary
			align = "bottom",					 -- How to align the notification window
			relative = "editor",				-- What the notification window position is relative to
		},
	},

	-- Options related to integrating with other plugins
	integration = {
		["nvim-tree"] = {
			enable = true,							-- Integrate with nvim-tree/nvim-tree.lua (if installed)
		},
	},

	-- Options related to logging
	logger = {
		level = vim.log.levels.WARN,	-- Minimum logging level
		float_precision = 0.01,			 -- Limit the number of decimals displayed for floats
		path =												-- Where Fidget writes its logs to
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

-- {{{ neodev
function config.neodev.config()
	require("neodev").setup({
		library = { plugins = { "nvim-dap-ui" }, types = true },
	})
end
-- }}}

-- {{{ ltex
function config.ltex.config()
	require("lspconfig").ltex.setup {
		capabilities = get_capabilities(),
		-- on_attach = function(client, bufnr)
		on_attach = function()
			require("ltex_extra").setup {
				load_langs = { "en-US" }, -- table <string> : languages for witch dictionaries will be loaded
				init_check = true,              -- boolean : whether to load dictionaries on startup
				path = nil,                     -- string : path to store dictionaries. Relative path uses current working directory
				log_level = "none",             -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
		}
		end,
		settings = {
			ltex = {
				language = "auto",
			}
		}
	}
end
-- }}}

return config
