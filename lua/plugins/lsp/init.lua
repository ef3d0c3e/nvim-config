local M = {
	-- Auto configure lsp
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				registries = {
					'github:mason-org/mason-registry',
				},
			})
		end,
		lazy = false,
	},

	{
		"neovim/nvim-lspconfig",
	},

	-- {{{ Completion engine
	{
		"saghen/blink.cmp",
		version = '*',
		--config = require "plugins.configs.lsp".blink.config,
		config = function()
			require "blink.cmp".setup {
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

				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},

				fuzzy = { implementation = "prefer_rust_with_warning" },

				completion = {
					-- 'prefix' will fuzzy match on the text before the cursor
					-- 'full' will fuzzy match on the text before _and_ after the cursor
					-- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
					keyword = { range = 'full' },

					-- Disable auto brackets
					-- NOTE: some LSPs may add auto brackets themselves anyway
					accept = {
						auto_brackets = {
							enabled = false
						},
					},

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
						},
  winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',

					},

					-- Show documentation when selecting a completion item
					documentation = { auto_show = true, auto_show_delay_ms = 500 },

					-- Display a preview of the selected item on the current line
					ghost_text = { enabled = true },
				},
			}
		end,
	},
	-- }}}

	---- Better diagnostics
	--{
	--	"rachartier/tiny-inline-diagnostic.nvim",
	--	priority = 1000, -- needs to be loaded in first
	--	config = require "plugins.configs.lsp".tiny_inline_diagnostic.config,
	--},

	---- Allow lsp injection via lua
	--{
	--	"nvimtools/none-ls.nvim",
	--},

	-- LSP indexing status
	{
		"j-hui/fidget.nvim",
		event = "VimEnter",
		config = function()
			require "fidget".setup {

			}
		end,
	},

	---- Telescope as action preview
	--{
	--	"aznhe21/actions-preview.nvim",
	--	dependencies = { "nvim-telescope/telescope.nvim" },
	--	config = require "plugins.configs.lsp".actions_preview.config,
	--},

	-- Additional LSP action handler
	--{
	--	"jinzhongjia/LspUI.nvim",
	--	branch = "main",
	--	config = require "plugins.configs.lsp".lspui.config,
	--},

	---- Icons
	--{
	--	"onsails/lspkind.nvim",
	--	config = require "plugins.configs.lsp".lspkind.config,
	--},

	-- Put lsp hints at the end
	--{
	--	"https://github.com/felpafel/inlay-hint.nvim",
	--	event = "LspAttach",
	--	config = require "plugins.configs.lsp".inlay_hints.config,
	--	branch = 'nightly',
	--	lazy = false,
	--},

	-- Setup servers
	require "plugins.lsp.clangd".plugins,
	require "plugins.lsp.rust-analyzer".plugins,
	--require "plugins.lsp.luals".plugins,
	--require "plugins.lsp.shell".plugins,
	--require "plugins.lsp.r".plugins,
}

---- Diagnostics symbols for display in the sign column.
--local signs = { Error = "", Warn = "", Hint = "󰛨", Info = "" }
--for type, icon in pairs(signs) do
--	local hl = "DiagnosticSign" .. type
--	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
--end

require "plugins.lsp.clangd".init()
require "plugins.lsp.rust-analyzer".init()
--require "plugins.lsp.luals".init()
--require "plugins.lsp.shell".init()
--require "plugins.lsp.r".init()

return M
