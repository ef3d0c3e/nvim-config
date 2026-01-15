return {
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},

	-- {{{ Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"lua",
					"html",
					"css",
					"javascript",
					"typescript",
					"tsx",
					"c",
					"cpp",
					"markdown",
					"markdown_inline",
					"bash",
					"dap_repl",
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
					filetypes = { "html" , "xml" },
				}
			})
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
			require ("multiple-cursors").setup({
				pre_hook = function()
					require("nvim-autopairs").disable()
				end,
				post_hook = function()
					require("nvim-autopairs").enable()
				end,
				custom_key_maps = {
					{"n", "<Leader>sa", function(_, count, motion_cmd, char)
						vim.cmd("normal " .. count .. "sa" .. motion_cmd .. char)
					end, "mc"},
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
			disable_in_macro = true, -- disable when recording or executing a macro
			disable_in_visualblock = false, -- disable when insert after visual block mode
			disable_in_replace_mode = true,
			ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
			enable_moveright = true,
			enable_afterquote = true, -- add bracket pairs after quote
			enable_check_bracket_line = true, --- check bracket in same line
			enable_bracket_in_quote = true, --
			enable_abbr = false, -- trigger abbreviation
			break_undo = true, -- switch for basic rule break undo sequence
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

	-- Doc
	{
		"https://github.com/danymat/neogen",
		config = function()
			require('neogen').setup({ snippet_engine = "luasnip" })
		end
	},

	-- Norminette lint
	{
		"https://github.com/FtVim/norminette-lint.nvim",
		config = function()
			require("norminette-lint").setup({
				enable_on_start = false, -- Default to false to improve startup performance
				keybinding = "<leader>uN", -- Default keybinding, you can define yours
			})
		end
	},

	{
		"Galac512/vim-aesenc",
		lazy = false,
	},
}
