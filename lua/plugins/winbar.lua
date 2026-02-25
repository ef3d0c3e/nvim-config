-- Incline winbar
local helpers = require "incline.helpers"
--local navic = require "nvim-navic"
local devicons = require "nvim-web-devicons"
local incline = require "incline"
local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
local normal_bg = string.format("#%x", normal.bg)

local theme = {
	git = {
		added = { icon = " ", style = { fg = "#2fba8f", bg = normal_bg } },
		changed = { icon = " ", style = { fg = "#2f9abf", bg = normal_bg } },
		removed = { icon = " ", style = { fg = "#af4a5f", bg = normal_bg } },
	},

	diagnostics = {
		ERROR = { icon = " ", style = { fg = "#cf2f2f", bg = normal_bg }},
		WARN = { icon = " ", style = { fg = "#cfcf4f", bg = normal_bg }},
		INFO = { icon = " ", style = { fg = "#2fcf7f", bg = normal_bg }},
		HINT = { icon = "󰌵 ", style = { fg = "#2f7fcf", bg = normal_bg }},
	},

	filetype_bg = "#2f2f39",

	filename = { fg = "#dfdfdf", bg = "#2f2f39", bold = true},
	filename_readonly = { fg = "#df4f9f", bg = "#2f2f39"},
	filename_modified = { fg = "#df5fdf", bg = "#2f2f39"},

	navic = { fg = "#dfdfdf", bg = normal_bg },
	navic_filename_sep = { fg = "#2f2f39", bg = normal_bg },
	navic_separator = { fg = "#9f9f9f", bg = normal_bg },
	navic_icons_bg = normal_bg,
}

-- {{{ Git
vim.api.nvim_set_hl(0, "WinbarGit_added", theme.git.added.style)
vim.api.nvim_set_hl(0, "WinbarGit_changed", theme.git.changed.style)
vim.api.nvim_set_hl(0, "WinbarGit_removed", theme.git.removed.style)
local function component_git(props)
	local signs = vim.b[props.buf].gitsigns_status_dict
	if not signs then
		return {}
	end

	local res = {}
	for name, icon in pairs(theme.git) do
		if tonumber(signs[name]) and signs[name] > 0 then
			table.insert(res, { icon.icon .. signs[name] .. " ", group = "WinbarGit_" .. name })
		end
	end
	return res
end
-- }}}

-- {{{ Diagnostics
vim.api.nvim_set_hl(0, "WinbarDiagnosticERROR", theme.diagnostics.ERROR.style);
vim.api.nvim_set_hl(0, "WinbarDiagnosticWARN", theme.diagnostics.WARN.style);
vim.api.nvim_set_hl(0, "WinbarDiagnosticINFO", theme.diagnostics.INFO.style);
vim.api.nvim_set_hl(0, "WinbarDiagnosticHINT", theme.diagnostics.HINT.style);
local function component_diagnostics(props)
	local res = {}

	for severity, icon in pairs(theme.diagnostics) do
		local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[severity] })
		if n > 0 then
			table.insert(res, { icon.icon .. n .. ' ', group = 'WinbarDiagnostic' .. severity })
		end
	end
	return res
end
-- }}}

-- {{{ Filetype
local function component_filetype(props, filename)
	local ft_icon, ft_color = devicons.get_icon_color(filename)

	if not ft_icon then
		return {}
	end
	return {
		{ ft_icon, guifg = ft_color, guibg = theme.filetype_bg }
	}
end
-- }}}

-- {{{ Filename
vim.api.nvim_set_hl(0, "WinbarFilename", theme.filename);
vim.api.nvim_set_hl(0, "WinbarFilenameSep", { fg = theme.filename.bg, bg = normal_bg });
vim.api.nvim_set_hl(0, "WinbarFilenameReadonly", theme.filename_readonly);
vim.api.nvim_set_hl(0, "WinbarFilenameModified", theme.filename_modified);
local function component_filename(props, filename)
	local modified = vim.bo[props.buf].modified
	local readonly = vim.bo[props.buf].readonly

	return {
		{ " ", group = "WinbarFilename" },
		readonly and { " 󰌾 ", group = "WinbarFilenameModified" } or "",
		{ filename, group = "WinbarFilename" },
		modified and { " 󰆓 ", group = "WinbarFilenameModified" } or "",
		--{ " ", group = "WinbarFilename" },
	}
end
-- }}}

-- {{{ Navic
--local groups = vim.fn.getcompletion('', 'highlight')
--for _, name in ipairs(groups) do
--	local typ = name:match('^NavicIcons(.+)$')
--	if typ then
--		local hi = vim.api.nvim_get_hl(0, { name = "NavicIcons" .. typ, link = false })
--		hi.bg = theme.navic_icons_bg
--		vim.api.nvim_set_hl(0, 'WinbarNavicIcons' .. typ, hi)
--	end
--end
--
--vim.api.nvim_set_hl(0, "WinbarNavicFilenameSep", theme.navic_filename_sep);
--vim.api.nvim_set_hl(0, "WinbarNavic", theme.navic);
--vim.api.nvim_set_hl(0, "WinbarNavicSeparator", theme.navic_separator);
--local function component_navic(props)
--	local res = {
--		{ "", group = "WinbarNavicFilenameSep" },
--	}
--	if not props.focused then
--		return res
--	end
--
--	for _, item in ipairs(navic.get_data(props.buf) or {}) do
--		table.insert(res, {
--			#res > 1 and { "  ", group = "WinbarNavicSeparator" } or { " ", group = "WinbarNavic" },
--			{ item.icon, group = "WinbarNavicIcons" .. item.type },
--			{ item.name, group = "WinbarNavic" },
--		})
--	end
--	if #res > 1 then
--		table.insert(res, { " ", group = "WinbarNavic" })
--	end
--	return res
--end
-- }}}

incline.setup {
	window = {
		padding = 0,
		margin = { horizontal = 0, vertical = 0 },
	},
	render = function(props)
		local prev = { value = false, color = nil }
		local function get_git_diff()
			local icons = { removed = ' ', changed = ' ', added = ' ' }
			local signs = vim.b[props.buf].gitsigns_status_dict
			local labels = {}
			if signs == nil then
				return labels
			end
			for name, icon in pairs(icons) do
				if tonumber(signs[name]) and signs[name] > 0 then
					if #labels ~= 0 then
						table.insert(labels, { " ", group = 'WinbarDiff_added' })
					end
					table.insert(labels, { icon .. signs[name], group = 'WinbarDiff_' .. name })
					prev = { value = true, color = "#2f2f39" }
				end
			end
			if #labels > 0 then
				table.insert(labels, { '', group = 'WinbarDiffSep' })
			end
			return labels
		end

		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
		if filename == '' then
			filename = '[No Name]'
		end
		local ft_icon, ft_color = devicons.get_icon_color(filename)
		local modified = vim.bo[props.buf].modified
		local res = {
			--component_git(props),
			component_diagnostics(props),
			{ "", group = "WinbarFilenameSep" },
			component_filetype(props, filename),
			component_filename(props, filename),
			{ "", group = "WinbarFilenameSep" },
			--component_navic(props),
		}
		return res
	end,
}
