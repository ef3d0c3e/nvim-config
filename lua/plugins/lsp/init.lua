local M = {
	-- Auto configure lsp
	{
		"williamboman/mason.nvim",
		config = require "plugins.configs.lsp".mason.config,
		lazy = false,
	},

	{
		"neovim/nvim-lspconfig",
	},

	-- Completion handler
	{
		"saghen/blink.cmp",
		version = '*',
		config = require "plugins.configs.lsp".blink.config,
	},

	-- Better diagnostics
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		priority = 1000, -- needs to be loaded in first
		config = require "plugins.configs.lsp".tiny_inline_diagnostic.config,
	},

	-- Allow lsp injection via lua
	{
		"nvimtools/none-ls.nvim",
	},

	-- LSP indexing status
	{
		"j-hui/fidget.nvim",
		event = "VimEnter",
		config = require "plugins.configs.lsp".fidget.config,
	},

	-- Telescope as action preview
	{
		"aznhe21/actions-preview.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = require "plugins.configs.lsp".actions_preview.config,
	},

	-- Additional LSP action handler
	--{
	--	"jinzhongjia/LspUI.nvim",
	--	branch = "main",
	--	config = require "plugins.configs.lsp".lspui.config,
	--},

	-- Icons
	{
		"onsails/lspkind.nvim",
		config = require "plugins.configs.lsp".lspkind.config,
	},

	-- Put lsp hints at the end
	--{
	--	"https://github.com/felpafel/inlay-hint.nvim",
	--	event = "LspAttach",
	--	config = require "plugins.configs.lsp".inlay_hints.config,
	--	branch = 'nightly',
	--	lazy = false,
	--},

	{
		"/home/user/code/nml-nvim/",
		dir = "/home/user/code/nml-nvim/",
		dev = true,
	},

	-- Setup servers
	require "plugins.lsp.clangd".plugins,
	require "plugins.lsp.rust-analyzer".plugins,
	require "plugins.lsp.luals".plugins,
	require "plugins.lsp.shell".plugins,
	require "plugins.lsp.r".plugins,
}

-- Diagnostics symbols for display in the sign column.
local signs = { Error = "", Warn = "", Hint = "󰛨", Info = "" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require "plugins.lsp.clangd".init()
require "plugins.lsp.rust-analyzer".init()
require "plugins.lsp.luals".init()
require "plugins.lsp.shell".init()
require "plugins.lsp.r".init()

return M
