-- Heirline status line
local function get_hl(name)
	local h = vim.api.nvim_get_hl(0, { name = name })
	return {
		fg = h.fg and string.format("#%06x", h.fg) or nil,
		bg = h.bg and string.format("#%06x", h.bg) or nil,
	}
end

local Normal = get_hl("Normal")

--local pill_separators = { "█", "█"}
--local pill_separators = { "", ""}
--local pill_separators = { "🭇🭄", "🭏🬼"}
--local pill_separators = { " ", " " }
local pill_separators = { "█", "█" }
--local pill_separators = { " ", " " }
--local pill_separators = { " ", " " }
--local pill_separators = { " ", " " }

-- Pill wrapper
local function Pill(component)
	-- Children list
	local children = {}

	-- If there are children, include them as-is
	if component.children and type(component.children) == "table" then
		for _, child in ipairs(component.children) do
			table.insert(children, child)
		end
	end

	-- Build the pill wrapper
	local pill = {}

	-- Cache
	if not component.pill_cache then
		component.pill_cache = {}
	end

	-- Cache highlight
	if not component.pill_cache.hl then
		component.pill_cache.hl = component.pill_cache.hl or (component.hl and component.hl() or { bg = Normal.bg })
	end

	local function edge_hl()
		if component.dynamic_hl == true then
			local c = component.hl and component.hl() or { bg = Normal.bg }
			return { fg = c.bg, bg = Normal.bg }
		end
		return { fg = component.pill_cache.hl.bg, bg = Normal.bg }
	end

	-- Left edge
	table.insert(pill, {
		provider = pill_separators[1],
		hl = edge_hl,
	})

	-- Parent
	table.insert(pill, {
		provider = component.provider,
		hl = component.hl,
		condition = component.condition,
		init = component.init,
	})

	-- Children
	for _, child in ipairs(children) do
		table.insert(pill, child)
	end

	-- Right edge
	table.insert(pill, {
		provider = pill_separators[2],
		hl = edge_hl,
	})

	return {
		condition = component.condition,
		pill,
		update = component.update,
	}
end

local theme = {
	project = { fg = "#aF70bF", bg = "#1f1f2a", bold = true },
	git = { fg = "#2f74af", bg = "#1f1f1f", bold = true },
	lsp = { fg = "#bf5f1f", bg = "#1f1f1f", bold = true },
	diagnostics = { fg = "#ffffff", bg = "#1f1f1f", bold = true },
	macro = { fg = "#f0dfaf", bg = "#1f1f1f", bold = true },
	encoding = { fg = "#af87d7", bg = "#1f1f1f", bold = true },
	newline = { fg = "#af87d7", bg = "#1f1f1f", bold = true },
	position = { fg = "#d78787", bg = "#1f1f1f", bold = true },
	clock = { fg = "#2f9fac", bg = "#1f1f1f", bold = true },
}

local function mode_color()
	local mode = vim.fn.mode()
	local colors = {
		n = { fg = "#000000", bg = "#98c379" }, -- Normal
		i = { fg = "#000000", bg = "#61afef" }, -- Insert
		v = { fg = "#000000", bg = "#c678dd" }, -- Visual
		V = { fg = "#000000", bg = "#c678dd" }, -- Visual Line
		['\22'] = { fg = "#000000", bg = "#c678dd" }, -- Visual Block
		c = { fg = "#000000", bg = "#e5c07b" }, -- Command
		R = { fg = "#000000", bg = "#e06c75" }, -- Replace
		s = { fg = "#000000", bg = "#56b6c2" }, -- Select
		S = { fg = "#000000", bg = "#56b6c2" },
		t = { fg = "#000000", bg = "#56b6c2" }, -- Terminal
	}
	return colors[mode] or { fg = "#000000", bg = "#abb2bf", bold = true }
end


-- {{{ Mode
local component_mode = Pill{
	provider = function()
		local symbols = {
			n = "𝐍",
			i = "𝐈",
			v = "𝐯",
			V = "𝐕",
			['\22'] = "^𝐕",
			c = "𝐂",
			R = "𝐑",
			s = "𝐬",
			S = "𝐒",
			t = "𝐓",
		}
		local mode = vim.fn.mode()

		return symbols[mode] or vim.fn.mode(1):sub(1,1):upper()
	end,
	dynamic_hl = true, -- Prevent caching
	hl = function()
		return mode_color()
	end,
	update = { "ModeChanged" },
}
-- }}}

-- {{{ Project
local function project_root()
	local buf = vim.api.nvim_get_current_buf()
	return vim.fs.root(buf, { ".git" }) or vim.fn.getcwd()
end

local component_project = Pill{
	provider = function()
		-- Try to get Git root
		local git_root = project_root()
		-- Fallback to cwd if no git repo
		local path = git_root ~= "" and git_root or vim.fn.getcwd()
		-- Return last directory name
		return "  " .. vim.fn.fnamemodify(path, ":t")
	end,
	hl = function()
		return theme.project
	end,
	update = { "BufEnter", "DirChanged" }
}
-- }}}

-- {{{ Git
local component_git = Pill{
	condition = function(self)
		return vim.b.gitsigns_head ~= nil
	end,
	provider = function(self)
		return "󰘬 " .. vim.b.gitsigns_head
	end,
	hl = function()
		return theme.git
	end,
	update = { "BufEnter", "WinEnter" },
}
-- }}}

-- {{{ LSP
local component_lsp = Pill{
	condition = function()
		return #vim.lsp.get_clients({ bufnr = 0 }) > 0
	end,

	provider = function()
		local names = {}
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			table.insert(names, client.name)
		end
		return "  " .. table.concat(names, " | ")
	end,
	hl = function()
		return theme.lsp
	end,
	update = { "BufEnter", "WinEnter" },
}
-- }}}

-- {{{ Diagnostics
local diag_icons = {
	ERROR = { icon = " ", style = { fg = "#cf2f2f", bg = theme.diagnostics.bg }},
	WARN = { icon = " ", style = { fg = "#cfcf4f", bg = theme.diagnostics.bg }},
	INFO = { icon = " ", style = { fg = "#2fcf7f", bg = theme.diagnostics.bg }},
	HINT = { icon = "󰌵 ", style = { fg = "#2f7fcf", bg = theme.diagnostics.bg }},
}

local need_space = false
local function diag_part(severity_name)
	local severity_num = vim.diagnostic.severity[severity_name] -- map name to number

	return {
		condition = function()
			local counts = vim.diagnostic.count(0)
			if counts[severity_num] and counts[severity_num] > 0 then
				need_space = true
				return true
			else
				return false
			end
		end,
		provider = function()
			local counts = vim.diagnostic.count(0)
			if severity_num == 1 then
				need_space = false
			end
			local component = (need_space and " " or "") .. diag_icons[severity_name].icon .. counts[severity_num]
			need_space = false
			return component
		end,
		hl = diag_icons[severity_name].style,
		update = { "DiagnosticChanged", "BufEnter" },
	}
end

local component_diagnostics = Pill{
	condition = function()
		return not vim.tbl_isempty(vim.diagnostic.get(0))
	end,
	hl = function() return theme.diagnostics end,
	children = 	{
		diag_part("ERROR"),
		diag_part("INFO"),
		diag_part("HINT"),
		diag_part("WARN"),
	},
	update = { "DiagnosticChanged", "BufEnter" },
}
-- }}}

-- {{{ Macro
local component_macro = Pill{
	condition = function()
		return vim.fn.reg_recording() ~= ""
	end,
	provider = function()
		return "Recording @" .. vim.fn.reg_recording()
	end,
	hl = function() return theme.macro end,
	update = { "ModeChanged" }
}
-- }}}

-- {{{ Encoding
local component_encoding = Pill{
	condition = function()
		return vim.bo.fileencoding and vim.bo.fileencoding ~= ""
	end,
	provider = function()
		return vim.bo.fileencoding:upper()
	end,
	hl = function() return theme.encoding end,
	update = { "BufEnter", "WinEnter", "OptionSet", "FileType" },
}
-- }}}

-- {{{ Newline
local component_newline = Pill{
	provider = function()
		local format = vim.bo.fileformat
		if format == "unix" then
			return "␊"
		elseif format == "dos" then
			return "␍␊"
		elseif format == "mac" then
			return "␍"
		else
			return format:upper()
		end
	end,
	hl = function() return theme.newline end,
	update = { "BufEnter", "WinEnter", "OptionSet", "FileType" },
}
-- }}}

-- {{{ Position
local component_position = Pill{
	provider = function()
		local mode = vim.fn.mode()
		if mode == "v" or mode == "V" or mode == "\22" then
			local start_pos = vim.fn.getpos("v")
			local end_pos   = vim.fn.getpos(".")
			local csrow, cscol = start_pos[2], start_pos[3]
			local cerow, cecol = end_pos[2], end_pos[3]
			local width  = math.abs(cecol - cscol) + 1
			local height = math.abs(cerow - csrow) + 1
			return string.format("%dx%d", width, height)
		else
			local line = vim.fn.line(".")
			local col = vim.fn.col(".")
			return string.format("%d:%d", line, col)
		end
	end,
	hl = function() return theme.position end,
	update = { "CursorMoved", "ModeChanged", "BufEnter" },
}
-- }}}

-- {{{ Clock
local component_clock = Pill{
	provider = function()
		return "  " .. os.date("%H:%M")
	end,
	hl = function() return theme.clock end,
}

-- Clock refresh timer
local timer = vim.loop.new_timer()
if timer then
	timer:start(0, 60000, vim.schedule_wrap(function()
		-- Force Heirline to redraw
		vim.cmd("redrawstatus!")
	end))
end
-- }}}

-- Transparent statusline background
vim.api.nvim_set_hl(0, "StatusLine", { bg = "None" })

return {
	-- LEFT
	{ provider = " " },
	component_mode,
	{ provider = " " },
	component_project,
	{
		provider = " ",
		condition = component_git.condition,
	},
	component_git,
	-- CENTER
	{ provider = "%=", hl = false },
	component_lsp,
	{
		provider = " ",
		condition =	component_diagnostics.condition,
	},
	component_diagnostics,
	{ provider = "%=", hl = false },
	-- RIGHT
	component_macro,
	{
		provider = " ",
		condition =	component_macro.condition,
	},
	component_encoding,
	{
		provider = " ",
		condition =	component_encoding.condition,
	},
	component_newline,
	{ provider = " " },
	component_position,
	{ provider = " " },
	component_clock,
}
