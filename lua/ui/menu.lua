local M = {}

-- {{{ Library
local function show_tags(tags)
	if not tags or #tags == 0 then return "" end

	return " +" .. table.concat(tags, " +");
end

local function show_keys(keys)
	if not keys then return "" end


	local function format(key)
		return string.gsub(key, "<leader>", "spc-")
	end

	if type(keys) == 'table' then
		local result = ""
		for _, key in ipairs(keys) do
			if #result > 0 then
				result = result .. " " .. format(key)
			else
				result = format(key)
			end
		end
		return " " .. result
	else
		return " " .. format(keys)
	end
end

local function show_cmd(cmd)
	if not cmd then return "" end

	return " :" .. cmd
end

local function get_icon(table, default)
	if table.icon then
		if type(table.icon) == "table" then
			assert(#table.icon == 2)
			return table.icon
		end
		return { table.icon, default[2] }
	end
	return default
end

local function MenuSub(table)
	table._init = function(self)
		if self.init then self:init() end
		local tags = show_tags(self.tags)
		local keys = show_keys(self.key)
		local cmd = show_cmd(self.command)
		self.text = self.desc .. (tags or "") .. (keys or "") .. (cmd or "")
		self._wk_icon = get_icon(self, { " ", "" })[1]
	end
	table.display = function(self)
		local tags = show_tags(self.tags)
		local keys = show_keys(self.key)
		local cmd = show_cmd(self.command)

		local icon = get_icon(self, { " ", "@property" })
		return {
			icon,
			{ " " },
			{ self.desc },
			{ tags,     "Comment", },
			{ keys,     "String", },
			{ cmd,      "String", },
		}
	end
	return table
end

local function MenuAction(table)
	table._init = function(self)
		if self.init then self:init() end
		local tags = show_tags(self.tags)
		local keys = show_keys(self.key)
		local cmd = show_cmd(self.command)
		self.text = self.desc .. (tags or "") .. (keys or "") .. (cmd or "")
		self._wk_icon = get_icon(self, { "󱐌 ", "" })[1]
	end
	table.display = function(self)
		local tags = show_tags(self.tags)
		local keys = show_keys(self.key)
		local cmd = show_cmd(self.command)

		local icon = get_icon(self, { "󱐌 ", "@diff.delta" })
		return {
			icon,
			{ " " },
			{ self.desc },
			{ tags,     "Comment", },
			{ keys,     "String", },
			{ cmd,      "String", },
		}
	end
	if table.command and not table.callback then
		table.callback = function(self)
			vim.cmd(self.command)
		end
	end
	return table
end

local function MenuToggle(table)
	table._init = function(self)
		if self.init then self:init() end
		local tags = show_tags(self.tags)
		local keys = show_keys(self.key)
		local cmd = show_cmd(self.command)
		self.text = self.desc .. (tags or "") .. (keys or "") .. (cmd or "")
		table._wk_icon = get_icon(self, { "󰦐 ", "" })[1]

		self._is_active = self:is_active()
	end
	local _callback = table.callback
	table.callback = function(self)
		_callback(self)
		self._is_active = self:is_active()
	end
	table.display = function(self)
		local tags = show_tags(self.tags)
		local keys = show_keys(self.key)
		local cmd = show_cmd(self.command)

		local icon = self._is_active and " " or " "
		local icon_hi = self._is_active and "@diff.plus" or "@diff.minus"
		return {
			{ icon,     icon_hi },
			{ " " },
			{ self.desc },
			{ tags,     "Comment", },
			{ keys,     "String", },
			{ cmd,      "String", },
		}
	end
	return table
end
-- }}}

local options = {
	--  NeoTree
	MenuSub {
		key = "<F3>",
		desc = "NeoTree",
		tags = { "ui" },
		callback = function(_)
			require "ui.neo_tree".picker()
		end
	},

	-- {{{ Misc
	-- Create snippet
	MenuAction { icon = " ", desc = "Add snippet", tags = { "snippets" }, command = "ScissorsAddNewSnippet", },
	-- Edit snippet
	MenuAction { icon = " ", desc = "Edit snippet", tags = { "snippets" }, command = "ScissorsEditSnippet", },

	-- Colorschemes
	MenuAction {
		key = "<leader>uC",
		desc = "Colorschemes",
		icon = " ",
		tags = { "ui", "menu" },
		callback = Snacks.picker.colorschemes
	},

	-- Highlight color codes
	MenuToggle {
		key = "<leader>uc",
		desc = "Toggle color highlighting",
		tags = { "ui", "menu" },
		is_active = function()
			return require "ui.color_highlight".is_active
		end,
		callback = function()
			require "ui.color_highlight".toggle()
		end
	},

	-- Toggle profiler
	MenuToggle {
		key = "<leader>up",
		desc = "Toggle profiler",
		tags = { "ui", "profiler" },
		is_active = Snacks.profiler.running,
		callback = Snacks.profiler.toggle,
	},

	-- Command history
	MenuAction {
		key = "<leader>:",
		desc = "Command history",
		icon = "󱣹 ",
		tags = { "command", "menu" },
		callback = Snacks.picker.command_history
	},

	MenuAction {
		key = "<leader>n",
		desc = "Notifications",
		icon = "󰅍 ",
		tags = { "menu" },
		callback = Snacks.picker.notifications
	},

	MenuAction {
		key = "<leader>b",
		desc = "Buffers",
		icon = " ",
		tags = { "menu" },
		callback = Snacks.picker.buffers
	},

	MenuAction {
		key = "<leader>t",
		desc = "Open Terminal",
		icon = " ",
		tags = { "ui", "terminal" },
		callback = function()
			vim.cmd.term()
			vim.cmd.startinsert()
		end
	},
	-- }}}

	-- Toggle numbers
	MenuToggle {
		key = "<leader>un",
		desc = "Toggle numbers",
		tags = { "ui" },
		is_active = function()
			return vim.api.nvim_get_option_value("number", { scope = "local" })
		end,
		callback = function(self)
			if self:is_active() then
				vim.opt.number = false
				vim.opt.relativenumber = false
			else
				vim.opt.number = true
				vim.opt.relativenumber = true
			end
		end,
	},

	-- Diagnostics
	MenuAction {
		key = "<leader>sd",
		desc = "Show diagnostics",
		tags = { "ui", "lsp", "diagnostics" },
		callback = Snacks.picker.diagnostics
	},

	-- Buffer diagnostics
	MenuAction {
		key = "<leader>sD",
		desc = "Show buffer diagnostics",
		tags = { "ui", "lsp", "diagnostics" },
		callback = Snacks.picker.diagnostics_buffer
	},

	-- Show highlights
	MenuAction {
		key = "<leader>sH",
		desc = "Highlights",
		icon = " ",
		tags = { "ui", "menu" },
		callback = Snacks.picker.highlights
	},

	-- Show help
	MenuAction {
		key = "<leader>sh",
		desc = "Help pages",
		icon = "󰮥 ",
		tags = { "ui", "menu" },
		callback = Snacks.picker.help
	},

	-- {{{ Finders
	MenuAction { key = "<leader>fc", icon = "󰍉 ", desc = "Find Config File", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
	end, },
	MenuAction { key = "<leader>ff", icon = "󰍉 ", desc = "Find Files", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.picker.files()
	end, },
	MenuAction { key = "<leader>fg", icon = "󰍉 ", desc = "Find Git Files", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.picker.git_files()
	end, },
	MenuAction { key = "<leader>fp", icon = "󰍉 ", desc = "Projects", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.picker.projects()
	end, },
	MenuAction { key = "<leader>fr", icon = "󰍉 ", desc = "Recent", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.picker.recent()
	end, },
	MenuAction { key = "<leader>fw", icon = "󰍉 ", desc = "Grep", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.picker.grep()
	end, },
	MenuAction { key = "<leader>fR", icon = "󰍉 ", desc = "Rename File", tags = { "ui", "menu", "finder" }, callback = function()
		Snacks.rename.rename_file()
	end, },
	-- }}}

	-- {{{ Git
	MenuToggle {
		desc = "Toggle Git Blame",
		tags = { "git", "ui" },
		init = function(self)
			self.active = true
		end,
		is_active = function(self)
			return self.active
		end,
		callback = function(self)
			self.active = require("gitsigns").toggle_current_line_blame()
		end
	},
	MenuAction { key = "<leader>Gb", desc = "Git Branches", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.picker.git_branches() end },
	MenuAction { key = "<leader>Gl", desc = "Git Log", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.picker.git_log() end },
	MenuAction { key = "<leader>GL", desc = "Git Log Line", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.picker.git_log_line() end },
	MenuAction { key = "<leader>Gs", desc = "Git Status", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.picker.git_status() end },
	MenuAction { key = "<leader>GS", desc = "Git Stash", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.picker.git_stash() end },
	MenuAction { key = "<leader>Gd", desc = "Git Diff (Hunks)", icon = "󰊢 ", tags = { "git" }, callback = function()
		Snacks.picker.git_diff() end },
	MenuAction { key = "<leader>Gf", desc = "Git Log File", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.picker.git_log_file() end },
	MenuAction { key = "<leader>GB", desc = "Git Browse", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.gitbrowse() end, },
	MenuAction { key = "<leader>Gg", desc = "Lazygit", icon = "󰊢 ", tags = { "git" }, callback = function() Snacks
			.lazygit() end },
	MenuAction { key = "<leader>Gi", desc = "GitHub Issues (open)", icon = "󰊢 ", tags = { "git" }, callback = function()
		Snacks.picker.gh_issue() end },
	MenuAction { key = "<leader>GI", desc = "GitHub Issues (all)", icon = "󰊢 ", tags = { "git" }, callback = function()
		Snacks.picker.gh_issue({ state = "all" }) end },
	MenuAction { key = "<leader>Gp", desc = "GitHub Pull Requests (open)", icon = "󰊢 ", tags = { "git" }, callback = function()
		Snacks.picker.gh_pr() end },
	MenuAction { key = "<leader>GP", desc = "GitHub Pull Requests (all)", icon = "󰊢 ", tags = { "git" }, callback = function()
		Snacks.picker.gh_pr({ state = "all" }) end },
	-- }}}

	-- {{{ LSP
	MenuAction {
		key = "<leader>uf",
		desc = "Format buffer",
		icon = "󰺲 ",
		tags = { "lsp" },
		callback = function() vim.lsp.buf.format({ async = false }) end
	},
	-- }}}
}

function M.show()
	---@diagnostic disable-next-line: undefined-global
	Snacks.picker({
		items = options,
		title = "Menu",
		layout = "select",

		format = function(item)
			return item:display()
		end,

		actions = {
			confirm = function(picker)
				local item = picker:selected({ fallback = true })[1]
				picker:close()

				if item then
					item:callback()
				end
			end,
		},
	})
end

function M.setup()
	local wk = require("which-key")
	local table = {}
	for _, entry in ipairs(options) do
		entry:_init()
		if entry.key then
			if type(entry.key) == 'table' then
				for _, v in ipairs(entry.key) do
					table[#table + 1] = { v, function() entry:callback() end, desc = entry.desc, icon = entry._wk_icon }
				end
			else
				table[#table + 1] = { entry.key, function() entry:callback() end, desc = entry.desc, icon = entry
				._wk_icon }
			end
		end
	end
	wk.add(table)
end

return M
