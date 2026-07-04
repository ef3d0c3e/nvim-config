--- @module Displays buffer names when pressing C-w
local M = {}

local active_floats = {}

local function close_all()
	for _, win in ipairs(active_floats) do
		if vim.api.nvim_win_is_valid(win) then
			pcall(vim.api.nvim_win_close, win, true)
		end
	end
	active_floats = {}
end

function M.show_buffer_names()
	close_all()

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local cfg = vim.api.nvim_win_get_config(win)

		-- Skip existing floating windows to avoid weird recursion/stacking.
		if cfg.relative == "" then
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
				local name = vim.api.nvim_buf_get_name(buf)
				if name == "" then
					name = "[No Name]"
				else
					name = vim.fn.fnamemodify(name, ":t")
				end

				local label = " " .. name .. " "
				local text_w = vim.fn.strdisplaywidth(label)

				-- content width/height; border adds 2 columns and 2 rows
				local content_w = text_w
				local content_h = 1
				local outer_w = content_w + 2
				local outer_h = content_h + 2

				local win_w = vim.api.nvim_win_get_width(win)
				local win_h = vim.api.nvim_win_get_height(win)

				local row = math.max(math.floor((win_h - outer_h) / 2), 0)
				local col = math.max(math.floor((win_w - outer_w) / 2), 0)

				local float_buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, { label })

				local float_win = vim.api.nvim_open_win(float_buf, false, {
					relative = "win",
					win = win,
					row = row,
					col = col,
					width = content_w,
					height = content_h,
					style = "minimal",
					border = "single",
					focusable = false,
					noautocmd = true,
				})

				vim.api.nvim_set_option_value("winhl", "Normal:NormalFloat,FloatBorder:FloatBorder", { win = float_win })
				table.insert(active_floats, float_win)
			end
		end
	end

	vim.defer_fn(close_all, 1500)
end

function M.setup()
	require("which-key").add({
		{
			"<C-w>",
			group = function()
				M.show_buffer_names()
			end,
		},
	})
end

return M
