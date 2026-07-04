--- @module Heirline statusline
vim.api.nvim_set_hl(0, "StatusLine", { bg = "#101010" });
local utils = require "heirline.utils"
local icons_resolver = require "colr-icons.resolver"

local theme = {
	filename = {
		modified = "#af5f7f",
		lock = "#af5f7f",
	}
}

-- {{{ Mode
local function mode_color()
	local mode = vim.fn.mode()
	local colors = {
		n = { fg = "#98c379" }, -- Normal
		i = { fg = "#61afef" }, -- Insert
		v = { fg = "#c678dd" }, -- Visual
		V = { fg = "#c678dd" }, -- Visual Line
		['\22'] = { fg = "#c678dd" }, -- Visual Block
		c = { fg = "#e5c07b" }, -- Command
		R = { fg = "#e06c75" }, -- Replace
		s = { fg = "#56b6c2" }, -- Select
		S = { fg = "#56b6c2" },
		t = { fg = "#56b6c2" }, -- Terminal
	}
	return colors[mode] or { fg = "#abb2bf" }
end

local component_mode = {
	provider = "▌",
	dynamic_hl = true, -- Prevent caching
	hl = mode_color,
	update = { "ModeChanged" },
}
-- }}}

-- {{{ Position
local component_position = {
	provider = function()
		local mode = vim.fn.mode()
		if mode == "v" or mode == "V" or mode == "\22" then
			local start_pos    = vim.fn.getpos("v")
			local end_pos      = vim.fn.getpos(".")
			local csrow, cscol = start_pos[2], start_pos[3]
			local cerow, cecol = end_pos[2], end_pos[3]
			local width        = math.abs(cecol - cscol) + 1
			local height       = math.abs(cerow - csrow) + 1
			return string.format("%dx%d", width, height)
		else
			local line = vim.fn.line(".")
			local col = vim.fn.col(".")
			return string.format("%d:%d", line, col)
		end
	end,
	update = { "CursorMoved", "ModeChanged", "BufEnter" },
}
-- }}}

-- {{{ File
local file_block = {
	init = function(self)
		self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
		self.filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	end,
}
local file_block_filetype = {
	init = function(self)
		self.icon = { text = nil }
		if vim.bo.buftype == "terminal" then
			self.icon = { text = "  " }
			return
		elseif vim.bo.buftype == "" then
			if self.filename then
				self.icon = icons_resolver.resolve_with_fallback({
					is_dir = false,
					filename = self.filename,
					ft = self.filetype,
					is_open = false,
				})
				if self.icon.text then
					self.icon.text = self.icon.text .. " "
				end
			end
		end
	end,
	provider = function(self)
		return self.icon.text or ""
	end,
}

local file_block_filename = {
	condition = function()
		return vim.bo.buftype == ""
	end,
	init = function(self)
		if not self.filename then
			self.fname_path = ""
			self.fname = "[No Name]"
		end

		local byte = string.byte
		local function last_index_of(str, search_b, idx)
			idx = idx or -1
			::again::
			local b = byte(str, idx)
			if b == nil then
				return
			elseif b == search_b then
				return idx
			end
			idx = idx - 1
			goto again
		end
		local idx = last_index_of(self.filename, string.byte("/")) or 0
		idx = idx + 1
		self.fname = self.filename:sub(idx)
		if idx ~= 1 then
			self.fname_path = self.filename:sub(1, #self.filename + idx)
		end
	end,
	{
		{
			provider = function(self)
				return self.fname_path
			end,
		},
		{
			provider = function(self)
				return self.fname
			end,
			hl = { bold = true, }
		},
	},
}

local file_block_termname = {
	condition = function()
		return vim.bo.buftype == "terminal"
	end,
	provider = function()
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return tname
	end,
}

local file_block_helpname = {
	condition = function()
		return vim.bo.buftype == "help"
	end,
	provider = function()
		local filename = vim.api.nvim_buf_get_name(0)
		return vim.fn.fnamemodify(filename, ":t")
	end,
}

local file_block_flags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "  ",
		hl = { fg = theme.filename.modified },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "  ",
		hl = { fg = theme.filename.lock },
	},
}

file_block = utils.insert(file_block,
	file_block_filetype,
	file_block_filename,
	file_block_termname,
	file_block_helpname,
	file_block_flags,
	{ provider = '%<' }
)
-- }}}

-- {{{ Diagnostics
local diag_icons = {
	ERROR = { icon = " ", style = { fg = "#ee5396" } },
	WARN = { icon = " ", style = { fg = "#be95ff" } },
	INFO = { icon = " ", style = { fg = "#78a9ff" } },
	HINT = { icon = "󰌵 ", style = { fg = "#d0d0d0" } },
}

local function format_diag_number(n)
	local set = {
		"⁰",
		"¹",
		"²",
		"³",
		"⁴",
		"⁵",
		"⁶",
		"⁷",
		"⁸",
		"⁹",
	}

	return tostring(n):gsub("%d", function(d)
		return set[tonumber(d) + 1]
	end)
end

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
			local component = (need_space and " " or "") ..
				diag_icons[severity_name].icon .. format_diag_number(counts[severity_num])
			need_space = false
			return component
		end,
		hl = diag_icons[severity_name].style,
		update = { "DiagnosticChanged", "BufEnter" },
	}
end

local block_diagnostics = {
	condition = function()
		return not vim.tbl_isempty(vim.diagnostic.get(0))
	end,
	{
		diag_part("ERROR"),
		diag_part("INFO"),
		diag_part("HINT"),
		diag_part("WARN"),
	},
	update = { "DiagnosticChanged", "BufEnter" },
}
-- }}}

-- {{{ Macro
local block_macro = {
	condition = function()
		return vim.fn.reg_recording() ~= ""
	end,
	provider = function()
		return "[@" .. vim.fn.reg_recording() .. "]"
	end,
	hl = { fg = "#7f7f7f", bold = true },
	update = { "ModeChanged" }
}
-- }}}

-- {{{ Git
local block_git = {
	condition = function()
		return vim.b.gitsigns_head ~= nil
	end,
	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,


	{ -- git branch name
		provider = function(self)
			return self.status_dict.head
		end,
		hl = { bold = true }
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and " - "
		end,
		hl = "@diff.minus",
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and tostring(count)
		end,
	},

	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and " + "
		end,
		hl = "@diff.plus",
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and tostring(count)
		end,
	},
}
-- }}}

-- {{{ LSP
local block_lsp = {
	condition = function()
		return #vim.lsp.get_clients({ bufnr = 0 }) > 0
	end,

	provider = function()
		local names = {}
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			table.insert(names, client.name)
		end
		local concat = table.concat(names, ", ")
		if #concat > 0 then
			return "󱐋 " .. concat .. " "
		end
		return ""
	end,
	update = { "BufEnter", "WinEnter" },
}
-- }}}

return {
	component_mode,
	{ provider = " " },
	component_position,
	{ provider = "  " },
	file_block,
	{ provider = "%=", hl = false },
	block_diagnostics,
	block_macro,
	{ provider = "%=", hl = false },
	block_git,
	{ provider = "  " },
	block_lsp,
}
