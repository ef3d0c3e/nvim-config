local heirline = require("heirline")

local function get_hl(name)
	local h = vim.api.nvim_get_hl(0, { name = name })
	return {
		fg = h.fg and string.format("#%06x", h.fg) or nil,
		bg = h.bg and string.format("#%06x", h.bg) or nil,
	}
end

local Normal = get_hl("Normal")
local StatusLine = get_hl("StatusLine")

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

	-- Left edge
	table.insert(pill, {
		provider = "",
		hl = function()
			local c = component.hl and component.hl() or { bg = Normal.bg }
			return { fg = c.bg, bg = Normal.bg }
		end,
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
		provider = "",
		hl = function()
			local c = component.hl and component.hl() or { bg = Normal.bg }
			return { fg = c.bg, bg = Normal.bg }
		end,
	})

	return {
		condition = component.condition,
		pill
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
	provider = function() return vim.fn.mode(1):sub(1,1):upper() end,
	hl = function()
		return mode_color()
	end,
	update = { "ModeChanged" },
}
-- }}}

-- {{{ Project
local component_project = Pill{
	provider = function()
		-- Try to get Git root
		local git_root
		local handle = io.popen("git rev-parse --show-toplevel 2> /dev/null")
		if handle then
			git_root = handle:read("*a")
			handle:close()
			git_root = git_root:gsub("%s+", "") -- trim newline
		end

		-- Fallback to cwd if no git repo
		local path = git_root ~= "" and git_root or vim.fn.getcwd()
		-- Return last directory name
		return " " .. vim.fn.fnamemodify(path, ":t")
	end,
	hl = function()
		return theme.project
	end,
}
-- }}}

-- {{{ Git
-- Cache for git repositories
local GIT = { cache = {} }
local function get_git_branch(cwd)
	local cmd = string.format(
		"git -C %q rev-parse --abbrev-ref HEAD 2> /dev/null",
		cwd
	)

	local handle = io.popen(cmd)
	if not handle then
		return nil
	end

	local branch = (handle:read("*a") or ""):gsub("%s+", "")
	handle:close()

	if branch == "" then
		return nil
	end

	return branch
end

local function in_git_dir(cwd)
	local branch = GIT.cache[cwd]
	return branch ~= nil and branch ~= false
end

vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
	callback = function()
		cwd = cwd or vim.loop.cwd()

		local branch = get_git_branch(cwd)
		if branch then
			GIT.cache[cwd] = branch
		else
			GIT.cache[cwd] = false
		end
		-- force heirline redraw
		vim.cmd("redrawstatus")
	end,
})

local component_git = Pill{
	condition = function(self)
		return in_git_dir(vim.loop.cwd()) -- This condition is ignored
	end,
	provider = function(self)
		local cwd = vim.loop.cwd()
		if in_git_dir(cwd) then
			return "󰘬 " .. GIT.cache[cwd]
		else
			return "󰘬 " .. "unknown"
		end
	end,
	hl = function()
		return theme.git
	end,
}
-- }}}
--
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
		return " " .. table.concat(names, " | ")
	end,

	hl = function()
		return theme.lsp
	end,
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
	}
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
}
-- }}}

-- {{{ Newline
local component_newline = Pill{
	provider = function()
		local format = vim.bo.fileformat
		if format == "unix" then
			return "LF"
		elseif format == "dos" then
			return "CRLF"
		elseif format == "mac" then
			return "CR"
		else
			return format:upper()
		end
	end,
	hl = function() return theme.newline end,
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

-- Setup heirline
heirline.setup {
	statusline = {
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

	},
}

-- Transparent statusline background
vim.api.nvim_set_hl(0, "StatusLine", { bg = "None" })
