local wk = require("which-key")

-- Main menu
wk.register({
	["<leader>"] = {
		-- Execute any action
		["e"] = { "<cmd>Legendary<cr>", "Execute actions" },
		-- Open terminal
		["x"] = { "<cmd>ToggleTerm<cr>", "Toggle terminal" },
		-- Finder
		f = {
				name = "Finder",
				f = { "<cmd>Telescope find_files<cr>", "Find files" },
				a = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", "Find all" },
				w = { "<cmd>Telescope live_grep<cr>", "Live grep" },
				b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
				h = { "<cmd>Telescope help_tags<cr>", "Help page" },
				o = { "<cmd>Telescope oldfiles<cr>", "Find oldfiles" },
				z = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Find in current buffer" },
		},
		-- Git
		g = {
			name = "Git",
			f = { "<cmd>Telescope git_commits<cr>", "Find commits" },
		},
		v = {
			name = "Visuals",
			g = { "<cmd>lua require(\"plugins.configs.writing\").ibl.toggle()<cr>", "Toggle indent guides" },
			r = { "<cmd>lua require(\"plugins.configs.writing\").ibl.toggle_rainbow()<cr>", "Toggle rainbow indent guides" },
			R = { "<cmd>lua require(\"plugins.configs.writing\").rainbow.toggle()<cr>", "Toggle rainbow delimiters" },
			C = { "<cmd>Colortils<cr>", "Toggle color code highlighting" },
		},
		-- LSP
		l = {
			name = "LSP",
			d = { "<cmd>Telescope lsp_definitions<cr>", "Show defitinions" },
			D = { "<cmd>Telescope lsp_type_definitions<cr>", "Show type defitinions" },
			r = { "<cmd>Telescope lsp_references<cr>", "Show references" },
			i = { "<cmd>Telescope lsp_implementations<cr>", "Show implementation" },
			s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "List workspace symbols" },
			o = { "<cmd>Lspsaga outline<cr>", "Toggle outline" },

		},
	},
})

-- Other
wk.register({
	-- TODO: Fix toggle only closing file explorer with edgy
	["<F4>"] = { "<cmd>Neotree toggle<cr>", "Toggle file tree" },
	-- Paste and reindent using Ctrl-P
	["<C-P>"] = { "p=']", "Paste and reindent" },

})

-- Bufferline
wk.register({
	["gt"] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
	["gT"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous buffer" },
})

-- Other LSP bindings
wk.register({
	["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "Show defitinions" },
	["gD"] = { "<cmd>Telescope lsp_type_definitions<cr>", "Show type defitinions" },
	["gr"] = { "<cmd>Telescope lsp_references<cr>", "Show references" },
	["gi"] = { "<cmd>Telescope lsp_implementations<cr>", "Show implementations" },
	["gf"] = { "<cmd>lua require(\"actions-preview\").code_actions()<cr>", "Code action" },
	["gR"] = { "<cmd>LspUI rename<cr>", "Rename under cursor" },
})
