return {
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},

	-- Multiple cursors
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

	-- {{{ Snippets
	-- Automatic snippets creation
	{
		"chrisgrieser/nvim-scissors",
		event = "BufEnter",
		opts = { snippetDir = vim.fn.stdpath("config") .. "/snippets" },
	},
	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "chrisgrieser/nvim-scissors" },
		version = "v2.*",
		build = "make install_jsregexp",
		config = function()
			local ls = require "luasnip"
			ls.setup()
			vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })
			require "misc.snippets".setup(ls)
			require("luasnip.loaders.from_vscode").lazy_load {
				paths = { vim.fn.stdpath("config") .. "/snippets" },
			}
		end
	},
	-- }}}

	-- Autopair
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

	{
		"ef3d0c3e/nvpass",
		opts = {
			vault_bin = vim.fn.expand("~/.install/bin/nvpass"),
		}
	},
}
