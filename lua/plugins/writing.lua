return {
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},

	-- {{{ Snippets
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
	},
	-- }}}

	-- {{{ Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		lazy = false,
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath('data') .. '/site',
				ensure_installed = {
					"lua", "c", "cpp", "rust", "javascript", "typescript",
				},
				highlight = {
					enable = true,
					use_languagetree = true,
				},

				indent = { enable = true },

				-- Settings for nvim-ts-autotag
				autotag = {
					enable = true,
					enable_rename = true,
					enable_close = true,
					enable_close_on_slash = true,
					filetypes = { "html", "xml" },
				}
			})
		end
	},
	-- }}}

	-- {{{ Doxygen
	{
		"ef3d0c3e/doxyvim",
		opts = {},
	},

	-- Generate doxygen templates upon `:Neogen`
	{
		"https://github.com/danymat/neogen",
		config = function()
			require('neogen').setup({
				snippet_engine = "nvim" })
		end
	},
	-- }}}

	-- {{{ treesitter-context: Show current function declaration
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require "treesitter-context".setup {
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = false, -- Enable multiwindow support.
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			}
		end
	},
	-- }}}

	-- {{{ Multiple cursors
	{
		"brenton-leighton/multiple-cursors.nvim",
		version = "*",
		keys = {
			{ "<C-j>",         "<Cmd>MultipleCursorsAddDown<CR>",        mode = { "n", "x" } },
			{ "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",        mode = { "n", "i", "x" } },
			{ "<C-k>",         "<Cmd>MultipleCursorsAddUp<CR>",          mode = { "n", "x" } },
			{ "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",          mode = { "n", "i", "x" } },
			{ "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
			{ "<Leader>a",     "<Cmd>MultipleCursorsAddMatches<CR>",     mode = { "n", "x" } },
		},
		config = function()
			require("multiple-cursors").setup({
				pre_hook = function()
					require("nvim-autopairs").disable()
				end,
				post_hook = function()
					require("nvim-autopairs").enable()
				end,
				custom_key_maps = {
					{ "n", "<Leader>sa", function(_, count, motion_cmd, char)
						vim.cmd("normal " .. count .. "sa" .. motion_cmd .. char)
					end, "mc" },
				},
			})
		end
	},
	-- }}}

	-- {{{ Auto pairs
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {
			---@diagnostic disable-next-line: unused-local
			enabled = function(bufnr) return true end, -- control if auto-pairs should be enabled when attaching to a buffer
			disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },
			disable_in_macro = true,          -- disable when recording or executing a macro
			disable_in_visualblock = false,   -- disable when insert after visual block mode
			disable_in_replace_mode = true,
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
			enable_moveright = true,
			enable_afterquote = true, -- add bracket pairs after quote
			enable_check_bracket_line = true, --- check bracket in same line
			enable_bracket_in_quote = true, --
			enable_abbr = false,     -- trigger abbreviation
			break_undo = true,       -- switch for basic rule break undo sequence
			check_ts = false,
			map_cr = true,
			map_bs = true, -- map the <BS> key
			map_c_h = false, -- Map the <C-h> key to delete a pair
			map_c_w = false, -- map <c-w> to delete a pair if possible
		}
	},
	-- }}}

	-- Auto align
	{
		"tommcdo/vim-lion",
		config = function() end,
	},

	{
		"ef3d0c3e/nvpass",
		opts = {
			vault_bin = vim.fn.expand("~/code/nvpass/target/debug/nvpass"),
		}
	},

	--{
	--	"Galac512/vim-aesenc",
	--	lazy = false,
	--},
	--{
	--	'isakbm/gitgraph.nvim',
	--	opts = {
	--		git_cmd = "git",
	--		symbols = {
	--			merge_commit = '',
	--			commit = '',
	--			merge_commit_end = '',
	--			commit_end = '',

	--			-- Advanced symbols
	--			GVER = '',
	--			GHOR = '',
	--			GCLD = '',
	--			GCRD = '╭',
	--			GCLU = '',
	--			GCRU = '',
	--			GLRU = '',
	--			GLRD = '',
	--			GLUD = '',
	--			GRUD = '',
	--			GFORKU = '',
	--			GFORKD = '',
	--			GRUDCD = '',
	--			GRUDCU = '',
	--			GLUDCD = '',
	--			GLUDCU = '',
	--			GLRDCL = '',
	--			GLRDCR = '',
	--			GLRUCL = '',
	--			GLRUCR = '',
	--		},
	--		format = {
	--			timestamp = '%H:%M:%S %d-%m-%Y',
	--			fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
	--		},
	--		hooks = {
	--			on_select_commit = function(commit)
	--				print('selected commit:', commit.hash)
	--			end,
	--			on_select_range_commit = function(from, to)
	--				print('selected range:', from.hash, to.hash)
	--			end,
	--		},
	--	},
	--	keys = {
	--		{
	--			"<leader>gl",
	--			function()
	--				require('gitgraph').draw({}, { all = true, max_count = 5000 })
	--			end,
	--			desc = "GitGraph - Draw",
	--		},
	--	},
	--},

	{
		"brianhuster/live-preview.nvim",
		dependencies = {
			-- You can choose one of the following pickers
			'nvim-telescope/telescope.nvim',
			'ibhagwan/fzf-lua',
			'echasnovski/mini.pick',
			'folke/snacks.nvim',
		},
	}
}
