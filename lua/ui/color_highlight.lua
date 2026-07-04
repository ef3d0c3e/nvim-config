--- @module Highlight color codes

local M = {
	is_active = false,
}

M.ns = vim.api.nvim_create_namespace("highlight_colors")

local function get_fg_color(bg)
	print(type(bg))
	local r = bit.band(bit.rshift(bg, 16), 0xFF)
	local g = bit.band(bit.rshift(bg, 8), 0xFF)
	local b = bit.band(bg, 0xFF)

	r = 255 - r
	g = 255 - g
	b = 255 - b
	local fg = bit.bor(bit.bor(bit.lshift(r, 16), bit.lshift(g, 8)), b)
	return string.format("#%06x", fg)
end

vim.api.nvim_set_decoration_provider(M.ns, {
	on_win = function(_, _, bufnr)
		if not M.is_active then
			vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)
			return
		end

		vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)

		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

		for lnum, line in ipairs(lines) do
			for s, color in line:gmatch("()#(%x%x%x%x%x%x)") do
				local group = "HexColor" .. color

				if vim.fn.hlexists(group) == 0 then
					vim.api.nvim_set_hl(0, group, {
						bg = "#" .. color,
						fg = get_fg_color(tonumber(color, 16)),
					})
				end

				vim.api.nvim_buf_set_extmark(bufnr, M.ns, lnum - 1, s - 1, {
					end_col = s + 6,
					hl_group = group,
				})
			end
		end
	end,
})

function M.toggle()
	M.is_active = not M.is_active

	-- Clear existing highlights when disabling.
	if not M.is_active then
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			vim.api.nvim_buf_clear_namespace(bufnr, M.ns, 0, -1)
		end
	end

	-- Force the decoration provider to run again.
	vim.cmd("redraw!")
end

function M.setup()
end

return M
