local wk = require("which-key")

wk.add({
	{ "<leader>x", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal", mode = "n"},
	{ "<leader>t", "<cmd>term<cr>i", desc = "Open Terminal", mode = "n"},
	{ "<leader>T", "<cmd>Telescope<cr>", desc = "Telescope", mode = "n" },
	{ "<leader>b", group = "buffers", expand = function() return require("which-key.extras").expand.buf() end },
	{ "<leader>d", "<cmd>Telescope man_pages<cr>", desc = "Open Manual", mode = "n" },

	-- Finder
	{ "<leader>f", group = "Finder" },
	{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files", mode = "n" },
	{ "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "Find all", mode = "n" },
	{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Live grep", mode = "n" },
	{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers", mode = "n" },
	{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help page", mode = "n" },
	{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find oldfiles", mode = "n" },
	{ "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current buffer", mode = "n" },

	-- Git
	{ "<leader>g", group = "Git" },
	{ "<leader>gf", "<cmd>Telescope git_commits<cr>", desc = "Find commits" },
	{ "<leader>gF", "<cmd>Telescope git_files<cr>", desc = "Find files" },
	{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
	{ "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git stash" },
	{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Find branches" },

	-- Lsp
	{ "<leader>l", group = "LSP" },
	{ "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", desc = "Show defitinions", mode="n" },
	{ "<leader>lD", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Show type defitinions", mode="n" },
	{ "<leader>lr", "<cmd>Telescope lsp_references<cr>", desc = "Show references", mode="n" },
	{ "<leader>li", "<cmd>Telescope lsp_implementations<cr>", desc = "Show implementation", mode="n" },
	{ "<leader>ls", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "List workspace symbols", mode="n" },
	{ "<leader>lo", "<cmd>Lspsaga outline<cr>", desc = "Toggle outline", mode="n" },
})

-- Other
wk.add({
	-- TODO: Fix toggle only closing file explorer with edgy
	{ "<F4>", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
	-- Paste and reindent using Ctrl-P
	{ "<C-P>", "p=']", desc = "Paste and reindent" },

})

-- Bufferline
wk.add({
	{ "gt", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
	{ "gT", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
	{ "gy", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer +1" },
	{ "gY", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer -1" },
})

-- Other LSP bindings
wk.add({
	{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Defitinions", mode="n"},
	{ "gD", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Defitinions", mode="n"},
	{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", mode="n"},
	{ "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations", mode="n"},
	{ "gI", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Incomind Calls", mode="n"},
	{ "gO", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Outgoing Calls", mode="n"},
	{ "gs", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols", mode="n"},
	{ "gf", "<cmd>lua require(\"actions-preview\").code_actions()<cr>", desc = "Code action", mode="n"},
	{ "gh", "<cmd>LspUI hover<cr>", desc = "Hover Symbol", mode="n"},
	{ "gR", "<cmd>LspUI rename<cr>", desc = "Rename", mode="n"},
})
