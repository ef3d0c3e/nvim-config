--- @module Neo-Tree configuration & Menu using snacks picker
local M = {}

function M.picker()
	Snacks.picker.pick({
		title = "Neo-Tree",
		layout = "select",
		format = "text",

		finder = function()
			return {
				{ text = " Toggle", callback = function() vim.cmd("Neotree toggle") end },
				{ text = " Filesystem", callback = function() vim.cmd("Neotree filesystem") end },
				{ text = "󰉹 Buffers", callback = function() vim.cmd("Neotree buffers") end },
				{ text = " Git Status", callback = function() vim.cmd("Neotree git_status") end },
				{ text = " Right", callback = function() vim.cmd("Neotree right") end },
				{ text = " Left", callback = function() vim.cmd("Neotree left") end },
			}
		end,

		actions = {
			confirm = function(picker)
				local item = picker:selected({ fallback = true })[1]
				picker:close()

				if item then
					item.callback()
				end
			end,
		},
	})
end

function M.config()
	require("neo-tree").setup {
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1, -- extra padding on left hand side
				-- indent guides
				with_markers = false,
				indent_marker = "│",
				last_indent_marker = "│",
				highlight = "NeoTreeIndentMarker",
				-- expander config, needed for nesting files
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			modified = {
				symbol = "󰳻 ",
				highlight = "NeoTreeModified",
			},
		},
	}
end

return M
