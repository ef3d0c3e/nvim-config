-- ui/statuscol.lua
local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic

local hi_numbers = vim.api.nvim_get_hl(0, { name = "LineNr", link = false })
local hi_numbers_cursor = vim.api.nvim_get_hl(0, { name = "CursorLineNr", link = false })
local hi_foldcolumn = vim.api.nvim_get_hl(0, { name = "FoldColumn", link = false });
local bg = "#2f2f37"
local theme = {
	numbers = { fg = hi_numbers.bg, bg = bg },
	numbers_cursor = { fg = hi_numbers_cursor.bg, bg = bg },

	diagnostics = {
		[1] = { icon = " ", style = { fg = "#cf2f2f", bg = bg } },
		[2] = { icon = " ", style = { fg = "#cfcf4f", bg = bg } },
		[3] = { icon = " ", style = { fg = "#2fcf7f", bg = bg } },
		[4] = { icon = "󰌵 ", style = { fg = "#2f7fcf", bg = bg } },
		none = { bg = bg },
	},

	fold_open = { icon = " ", style = { fg = hi_foldcolumn.fg, bg = bg } },
	fold_closed = { icon = " ", style = { fg = hi_foldcolumn.fg, bg = bg } },
	fold_none = { fg = hi_foldcolumn.fg, bg = bg },

	git = {
		add = { icon = "▍", style = { fg = "#2fba8f", bg = bg } },
		change = { icon = "▍", style = { fg = "#2f9abf", bg = bg } },
		delete = { icon = "𜰉", style = { fg = "#af4a5f", bg = bg } },
		none = { bg = bg },
	},

	virtual = { bg = bg },
}

-- {{{ Numbers
vim.api.nvim_set_hl(0, "StatuscolNumber", theme.numbers)
vim.api.nvim_set_hl(0, "StatuscolNumberCursor", theme.numbers)
local component_numbers = {
	condition = function() return vim.v.virtnum == 0 end,
	provider = function()
		if vim.v.relnum == 0 then
			return string.format("%3d ", vim.v.lnum)
		end
		return string.format("%3d ", vim.v.relnum)
	end,
	hl = function()
		return vim.v.relnum == 0 and "StatuscolNumberCursor" or "StatuscolNumber"
	end,
}
-- }}}

-- {{{ Diagnostics
vim.api.nvim_set_hl(0, "StatuscolDiagnostic", theme.diagnostics.none)
vim.api.nvim_set_hl(0, "StatuscolDiagnostic_1", theme.diagnostics[1].style)
vim.api.nvim_set_hl(0, "StatuscolDiagnostic_2", theme.diagnostics[2].style)
vim.api.nvim_set_hl(0, "StatuscolDiagnostic_3", theme.diagnostics[3].style)
vim.api.nvim_set_hl(0, "StatuscolDiagnostic_4", theme.diagnostics[4].style)
local component_diagnostics = {
	condition = function() return vim.v.virtnum == 0 end,
	init = function(self)
		self.icon = nil
		self.hl = "StatuscolDiagnostic"

		local diags = diagnostic.get(0, { lnum = vim.v.lnum - 1 })
		if #diags == 0 then
			return
		end

		for _, d in ipairs(diags) do
			local icon = theme.diagnostics[d.severity]
			if icon then
				self.icon = icon.icon
				self.hl = "StatuscolDiagnostic_" .. d.severity
				return
			end
		end
	end,

	provider = function(self)
		return self.icon or "  "
	end,
}
-- }}}

-- {{{ Fold
vim.api.nvim_set_hl(0, "StatuscolFold", theme.fold_none)
vim.api.nvim_set_hl(0, "StatuscolFoldClosed", theme.fold_closed.style)
vim.api.nvim_set_hl(0, "StatuscolFoldOpen", theme.fold_open.style)
local component_fold = {
	condition = function() return vim.v.virtnum == 0 end,
	provider = function(self)
		local lnum = vim.v.lnum

		if fn.foldlevel(lnum) <= fn.foldlevel(lnum - 1) then
			self.hl = "StatuscolFold"
			return "  "
		end

		if fn.foldclosed(lnum) == -1 then
			self.hl = "StatuscolFoldClosed"
			return theme.fold_closed.icon
		else
			self.hl = "StatuscolFoldOpen"
			return theme.fold_open.icon
		end
	end,
}
-- }}}

-- {{{ Git
vim.api.nvim_set_hl(0, "StatuscolGit", theme.git.none)
vim.api.nvim_set_hl(0, "StatuscolGit_add", theme.git.add.style)
vim.api.nvim_set_hl(0, "StatuscolGit_change", theme.git.change.style)
vim.api.nvim_set_hl(0, "StatuscolGit_delete", theme.git.delete.style)
local gs = package.loaded.gitsigns

local function git_status_at_line(bufnr, lnum)
	if not gs or not gs.get_hunks then
		return nil
	end

	local hunks = gs.get_hunks(bufnr)
	if not hunks then
		return nil
	end

	for _, hunk in ipairs(hunks) do
		local start = hunk.added.start
		local count = hunk.added.count

		-- deleted lines have count == 0
		if count == 0 then
			if lnum == start then
				return "delete"
			end
		else
			if lnum >= start and lnum < start + count then
				return hunk.type -- add | change | delete | changedelete
			end
		end
	end

	return nil
end

local component_git = {
	condition = function() return vim.v.virtnum == 0 end,
	init = function(self)
		self.kind = nil

		if vim.v.virtnum ~= 0 then
			return
		end

		self.kind = git_status_at_line(
			vim.api.nvim_get_current_buf(),
			vim.v.lnum
		)
	end,
	provider = function(self)
		self.hl = "StatuscolGit"
		local kind = theme.git[self.kind]
		if kind then
			self.hl = "StatuscolGit_" .. tostring(self.kind)
			return kind.icon
		end
		return " "
	end,
}
-- }}}

-- {{{ Virtual lines
vim.api.nvim_set_hl(0, "StatuscolVirtual", theme.virtual)
local component_virtlines = {
	condition = function() return vim.v.virtnum ~= 0 end,
	provider = function()
		return "         "
	end,
	hl = "StatuscolVirtual",
}
-- }}}

return {
	component_virtlines,
	component_git,
	component_fold,
	component_diagnostics,
	component_numbers,
}
