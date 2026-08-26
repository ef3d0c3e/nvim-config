local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

require("nvim")

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local lang_plugins = require("langs.config").plugins

require('lazy').setup(
	{
		{
			"WeiTing1991/suannhai.nvim",
			priority = 1000,
			config = function()
				vim.cmd("colorscheme suannhai-sumi")
			end,
		},
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{ import = "ui.plugins" },
		{ import = "misc.editing" },
		{ import = "misc.git" },
		{ import = "langs.treesitter" },
		{ import = "langs.lsp" },
		lang_plugins,
	},
	{
		rocks = {
			hererocks = true,
		},
		performance = {
			cache = { enabled = true },
			defaults = { lazy = true },
			checker = { enabled = false },
			rtp = {
				-- stylua: ignore
				disabled_plugins = {
					"gzip", 'netrw', "netrwPlugin",
					"rplugin", "tarPlugin",
					"tutor", "zipPlugin",
				},
			},
		},
		change_detection = {
			notify = false,
		},
	})

require("keymap")
require("ui.buf_switcher").setup()
require("ui.diagnostics").setup()
require("langs.config").setup()
require("ui.color_highlight").setup()
require("ui.menu").setup()
