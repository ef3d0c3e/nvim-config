local wk = require("which-key")

wk.add({
	-- {{{ Space menu
	-- Top Pickers & Explorer
	{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", icon = "" },
	{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
	{ "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
	{ "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
	{ "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },

	-- Files
	{ "<leader>f", group = "File" },
	{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
	{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
	{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
	{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
	{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
	{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
	{ "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
	{ "<leader>fR", function() Snacks.rename.rename_file() end, desc = "Rename File" },

	-- Git
	{ "<leader>g", group = "Git" },
	{ "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
	{ "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
	{ "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
	{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
	{ "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
	{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
	{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
	{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
	{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
	-- Github
	{ "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
	{ "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
	{ "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
	{ "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

	-- Search
	{ "<leader>s", group = "Search" },
	{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
	{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
	{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
	{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
	{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
	{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
	{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
	{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
	{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
	{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
	{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
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
	{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
	{ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
	-- }}}

	-- {{{ Splits
	-- Move
	{ "<A-h>", "<cmd>wincmd h<cr>", desc = "Move Left",  mode = "nit" },
	{ "<A-left>", "<cmd>wincmd h<cr>", desc = "Move Left",  mode = "nit" },
	{ "<A-j>", "<cmd>wincmd j<cr>", desc = "Move Down",  mode = "nit" },
	{ "<A-down>", "<cmd>wincmd j<cr>", desc = "Move Down",  mode = "nit" },
	{ "<A-k>", "<cmd>wincmd k<cr>", desc = "Move Up",    mode = "nit" },
	{ "<A-up>", "<cmd>wincmd k<cr>", desc = "Move Up",    mode = "nit" },
	{ "<A-l>", "<cmd>wincmd l<cr>", desc = "Move Right", mode = "nit" },
	{ "<A-right>", "<cmd>wincmd l<cr>", desc = "Move Right", mode = "nit" },
	-- Resize
	{ "<A-H>", "<cmd>vertical resize +2<cr>", desc = "Resize Left",  mode = "nit" },
	{ "<A-S-left>", "<cmd>vertical resize +2<cr>", desc = "Resize Left",  mode = "nit" },
	{ "<A-L>", "<cmd>vertical resize -2<cr>", desc = "Resize Right", mode = "nit" },
	{ "<A-S-right>", "<cmd>vertical resize -2<cr>", desc = "Resize Right", mode = "nit" },
	{ "<A-S-down>", "<cmd>resize -2<cr>", desc = "Resize Down", mode = "nit" },
	{ "<A-J>", "<cmd>resize -2<cr>", desc = "Resize Down", mode = "nit" },
	{ "<A-S-up>", "<cmd>resize +2<cr>", desc = "Resize Up", mode = "nit" },
	{ "<A-K>", "<cmd>resize +2<cr>", desc = "Resize Up", mode = "nit" },
	-- }}}


	-- TODO: Fix toggle only closing file explorer with edgy
	{ "<F4>", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
	-- Paste and reindent using Ctrl-P
	{ "<C-P>", "p=']", desc = "Paste and reindent" },
})
