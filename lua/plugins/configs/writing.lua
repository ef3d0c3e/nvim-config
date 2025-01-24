local config = {
	hlchunk = {},

	surround = {},

	autotag = {},

	ultimate_autopair = {},

	sad = {},

	ssr = {},
}

-- {{{ rainbow-delimiters
--function config.rainbow.update()
--	local rainbow_delimiters = require("rainbow-delimiters")
--
--	-- TODO: Fix disabling rainbow parens
--	rainbow_delimiters = {
--		strategy = {
--			[""] = rainbow_delimiters.strategy["global"],
--			vim = rainbow_delimiters.strategy["local"],
--		},
--		query = {
--			[""] = "rainbow-delimiters",
--			lua = "rainbow-blocks",
--			query = function(bufnr)
--        	    local is_nofile = vim.bo[bufnr].buftype == "nofile"
--        	    return is_nofile and "rainbow-blocks" or "rainbow-delimiters"
--        	end
--
--		},
--		priority = {
--				[""] = 110,
--				lua = 210,
--		},
--		highlight = {
--			"RainbowDelimiterRed",
--			"RainbowDelimiterYellow",
--			"RainbowDelimiterBlue",
--			"RainbowDelimiterOrange",
--			"RainbowDelimiterGreen",
--			"RainbowDelimiterViolet",
--			"RainbowDelimiterCyan",
--		},
--	}
--
--	if config.rainbow.enabled == false then
--		rainbow_delimiters.strategy = {}
--		rainbow_delimiters.highlight = { "Whitespace" }
--	end
--end

--function config.rainbow.toggle()
--	config.rainbow.enabled = not config.rainbow.enabled
--
--	config.rainbow.update()
--end
--
--
--function config.rainbow.init()
--	require("rainbow-delimiters.setup").setup()
--
--	config.rainbow.update()
--end
-- }}}

-- {{{ hlchunk
function config.hlchunk.config()
	require("hlchunk").setup({
		indent = {
			enable = true,
			chars = {
				"│",
			},
			style = { vim.api.nvim_get_hl(0, { name = "Whitespace" }) },
			use_treesitter = true,
			ahead_lines = 5,
			delay = 0,
		},
		chunk = {
			enable = true,
			priority = 15,
			style = {
				{ fg = "#80fd9c" },
				{ fg = "#c21f30" },
			},
			use_treesitter = true,
			chars = {
				horizontal_line = "─",
				vertical_line = "│",
				left_top = "╭",
				left_bottom = "╰",
				right_arrow = "─",
			},
			textobject = "",
			max_file_size = 1024 * 1024,
			error_sign = true,
			-- animation related
			duration = 0,
			delay = 100,
		},
		line_num = {
			style = "#806d9c",
			priority = 10,
			use_treesitter = true,
		}
	})
end
-- }}}

-- {{{ autotags
function config.autotag.config()
	vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        underline = true,
        virtual_text = {
            spacing = 5,
        },
        update_in_insert = true,
    })

	require("nvim-ts-autotag").setup({})
end
-- }}}

-- {{{ ultimate_autopair
function config.ultimate_autopair.config()
	require("ultimate-autopair").setup({})
end
-- }}}

-- {{{ sad
function config.sad.config()
	require'sad'.setup({
		debug = false, -- print debug info
		diff = 'delta', -- you can use `less`, `diff-so-fancy`
		ls_file = 'fd', -- also git ls-files
		exact = false, -- exact match
		vsplit = false, -- split sad window the screen vertically, when set to number
		-- it is a threadhold when window is larger than the threshold sad will split vertically,
		height_ratio = 0.6, -- height ratio of sad window when split horizontally
		width_ratio = 0.6, -- height ratio of sad window when split vertically

	})
end
-- }}}

-- {{{ ssr
function config.ssr.config()
	require("ssr").setup {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      adjust_window = true,
      keymaps = {
        close = "<esc>",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    }
end
-- }}}

return config
