--- @module Snippets mark indicator, requires luasnip

local M = {
	ls = nil,
}

local AUGROUP_NAME = "SnippetMarks"
local NS = vim.api.nvim_create_namespace("snippet_marks")

local exited = {}

--- Clear all jump-marker extmarks in a buffer.
---@param bufnr integer
local function clear(bufnr)
	if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
	end
end

--- Resolve the top-level snippet that owns the currently active node.
---@param ls table the luasnip module
---@param bufnr integer
---@return boolean, table|nil
local function active_snippet(ls, bufnr)
	local node = ls.session.current_nodes[bufnr]
	if not node then
		return false
	end


	local ok, snip = pcall(node.get_snippet, node)
	if not ok or not snip then
		return false
	end

	-- Exit node means snippet is done
	if snip.insert_nodes == nil then
		return false
	end

	return true, snip
end

--- Render one extmark per remaining insert node of the active snippet.
---@param bufnr integer
local function render(bufnr)
	clear(bufnr)


	if exited[bufnr] then
		return
	end

	local alive, snip = active_snippet(M.ls, bufnr)
	if not alive or not snip then
		clear(bufnr)
		return
	end

	local insert_nodes = snip.insert_nodes
	if not insert_nodes then
		clear(bufnr)
		return
	end

	local current = M.ls.session.current_nodes[bufnr]

	local current_index = 0
	for index, node in pairs(insert_nodes) do
		if node == current then
			current_index = index
			break
		end
	end

	local function mark_number(n)
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

	local function is_future(index, current_index)
		if current_index == 0 then
			return false
		end

		if index == 0 then
			return true
		end

		return index > current_index
	end

	for index, node in pairs(insert_nodes) do
		if node and node.mark and is_future(index, current_index) then
			local ok, from = pcall(function()
				local b = node.mark:pos_begin_end()
				return b
			end)
			if ok and from then
				local row, col = from[1], from[2]
				local is_current = node == current
				local hl = is_current and "SnippetMarkCurrent" or "SnippetMark"

				pcall(vim.api.nvim_buf_set_extmark, bufnr, NS, row, col, {
					virt_text = { { "" .. mark_number(index), hl } },
					virt_text_pos = "inline",
					hl_mode = "combine",
					priority = 200,
				})
			end
		end
	end
end

local function setup_autocmds()
	local group = vim.api.nvim_create_augroup(AUGROUP_NAME, { clear = true })


	local function render_current()
		render(vim.api.nvim_get_current_buf())
	end

	-- Fired by LuaSnip itself on node/choice transitions.
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = {
			"LuasnipSnippetEnter",
			"LuasnipInsertNodeEnter",
			"LuasnipInsertNodeLeave",
			"LuasnipChoiceNodeEnter",
			"LuasnipChoiceNodeLeave",
			"LuasnipChangeChoice",
			"LuasnipExitNodeEnter",
			"LuasnipSnippetLeave",
		},
		callback = function(args)
			local ev = args.match
			local bufnr = args.buf

			if ev == "LuasnipSnippetEnter" then
				exited[bufnr] = false
			elseif ev == "LuasnipExitNodeEnter" or ev == "LuasnipSnippetLeave" then
				exited[bufnr] = true
				clear(bufnr)
				return
			end

			vim.schedule(function()
				render(bufnr)
			end)
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP", "CursorMovedI" }, {
		group = group,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			if M.ls.session.current_nodes[bufnr] and not exited[bufnr] then
				render_current()
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "ModeChanged" }, {
		group = group,
		callback = function(args)
			local bufnr = args.buf
			vim.schedule(function()
				if not M.ls.session.current_nodes[bufnr] then
					exited[bufnr] = true
					clear(bufnr)
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		callback = function(args)
			exited[args.buf] = nil
			clear(args.buf)
		end,
	})
end

---@param bufnr integer|nil
function M.refresh(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	exited[bufnr] = false
	render(bufnr)
end

---@param expand_fn fun(snippet: string, opts: table|nil)
---@return fun(snippet: string, opts: table|nil)
function M.wrap_expand(expand_fn)
	return function(snippet, opts)
		local bufnr = vim.api.nvim_get_current_buf()
		local result = { expand_fn(snippet, opts) }
		vim.schedule(function()
			M.refresh(bufnr)
		end)
		return unpack(result)
	end
end

function M.setup(ls)
	M.ls = ls
	vim.api.nvim_set_hl(0, "SnippetMark", { link = "Comment", default = true })
	vim.api.nvim_set_hl(0, "SnippetMarkCurrent", { link = "WarningMsg", default = true })

	setup_autocmds()
end

return M
