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
					default = { 'lsp', 'path', 'snippets', 'buffer', "comment_source" },
					providers = {
						comment_source = {
							name = "Doxyvim",
							module = "doxyvim.blink_source",  -- <- This must match your require path
						},
					},
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

					---@diagnostic disable-next-line: unused-local
					list = { selection = { preselect = function(ctx) return vim.bo.filetype ~= 'markdown' end } },

					menu = {
						-- Don't automatically show the completion menu
						auto_show = true,

						-- nvim-cmp style menu
						draw = {
							columns = {
								{ "kind_icon" },
								{ "label",    "label_description", gap = 1 },
							},
						},
						winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',
					},

					-- Show documentation when selecting a completion item
					documentation = { auto_show = true, auto_show_delay_ms = 500 },

					-- Display a preview of the selected item on the current line
					ghost_text = { enabled = true },
				},
				signature = { enabled = true }
			}
		end,
	},
	-- }}}

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

	-- Diagnostics on the right
	{
		"ef3d0c3e/nvim-right-diagnostics",
		opts = {},
	},

	-- Setup servers
	require "plugins.lsp.clangd".plugins,
	require "plugins.lsp.rust-analyzer".plugins,
	require "plugins.lsp.shellcheck".plugins,
	require "plugins.lsp.luals".plugins,
	require "plugins.lsp.nml".plugins,
}

require "plugins.lsp.clangd".init()
require "plugins.lsp.rust-analyzer".init()
require "plugins.lsp.shellcheck".init()
require "plugins.lsp.luals".init()
require "plugins.lsp.nml".init()

return M
