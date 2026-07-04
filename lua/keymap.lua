local icons = require("colr-icons.icons")
local wk = require("which-key")

wk.add({
	-- Top Pickers & Explorer
	{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
	{ "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
	{ "<leader>e", function() require "ui.menu".show() end, desc = "Menu" },

	-- Files
	{ "<leader>f", group = "File" },

	-- Git
	{ "<leader>G", group = "Git", icon = icons.get_icon({ name = "git" }).text },

	-- Search
	{ "<leader>s", group = "Search", icon = icons.get_icon({ name = "search" }).text },
	{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
	{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
	{ '<leader>"', function() Snacks.picker.registers() end, desc = "Registers" },
	{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
	{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
	{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
	{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
	{ "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
	{ "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
	{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
	{ "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
	{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
	{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
	{ "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
	{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
	{ "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
	{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },

	-- Custom menu
	{ "<leader>u", group = "Menu", icon = "󰍜" },

	-- Move
	{ "<A-h>", "<cmd>wincmd h<cr>", desc = "Move Left", mode = "nit" },
	{ "<A-left>", "<cmd>wincmd h<cr>", desc = "Move Left", mode = "nit" },
	{ "<A-j>", "<cmd>wincmd j<cr>", desc = "Move Down", mode = "nit" },
	{ "<A-down>", "<cmd>wincmd j<cr>", desc = "Move Down", mode = "nit" },
	{ "<A-k>", "<cmd>wincmd k<cr>", desc = "Move Up", mode = "nit" },
	{ "<A-up>", "<cmd>wincmd k<cr>", desc = "Move Up", mode = "nit" },
	{ "<A-l>", "<cmd>wincmd l<cr>", desc = "Move Right", mode = "nit" },
	{ "<A-right>", "<cmd>wincmd l<cr>", desc = "Move Right", mode = "nit" },
	-- Resize
	{ "<A-H>", "<cmd>vertical resize -2<cr>", desc = "Resize Left", mode = "nit" },
	{ "<A-S-left>", "<cmd>vertical resize -2<cr>", desc = "Resize Left", mode = "nit" },
	{ "<A-L>", "<cmd>vertical resize +2<cr>", desc = "Resize Right", mode = "nit" },
	{ "<A-S-right>", "<cmd>vertical resize +2<cr>", desc = "Resize Right", mode = "nit" },
	{ "<A-S-down>", "<cmd>resize -2<cr>", desc = "Resize Down", mode = "nit" },
	{ "<A-J>", "<cmd>resize -2<cr>", desc = "Resize Down", mode = "nit" },
	{ "<A-S-up>", "<cmd>resize +2<cr>", desc = "Resize Up", mode = "nit" },
	{ "<A-K>", "<cmd>resize +2<cr>", desc = "Resize Up", mode = "nit" },

	{ "<F4>", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },

	-- Paste and reindent using Ctrl-P
	{ "<C-P>", "p=']", desc = "Paste and reindent" },
	-- Delete current buffer
	{ "<C-w>d", "<cmd>bd<cr>", desc = "Buffer delete", mode = "n" },
})

Snacks.keymap.set("n", "gf", vim.lsp.buf.code_action, {
	lsp = { method = "textDocument/codeAction" },
	desc = "Code Action",
})
wk.add({
	{ "gd",  function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
	{ "gD",  function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration" },
	{ "gr",  function() Snacks.picker.lsp_references() end,       nowait = true,                  desc = "References" },
	{ "gi",  function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
	{ "gy",  function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
	{ "gai", function() Snacks.picker.lsp_incoming_calls() end,   desc = "C[a]lls Incoming" },
	{ "gao", function() Snacks.picker.lsp_outgoing_calls() end,   desc = "C[a]lls Outgoing" },
	{ "gh",  "<cmd>lua vim.lsp.buf.hover()<cr>",                  desc = "Hover Symbol",          mode = "n" },
	{ "gR",  "<cmd>lua vim.lsp.buf.rename()<cr>",                 desc = "Rename",                mode = "n" },
})

-- Toggle the profiler highlights
Snacks.toggle.profiler_highlights():map("<leader>uh")
