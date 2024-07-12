local config = {
	rainbow = {
		enabled = false,
	},

	ibl = {
		rainbow = false,
		enabled = true,
	},

	surround = {},

	autopairs = {},

	autotag = {},
}

-- {{{ rainbow-delimiters
function config.rainbow.update()
	local rainbow_delimiters = require("rainbow-delimiters")

	-- TODO: Fix disabling rainbow parens
	rainbow_delimiters = {
		strategy = {
			[""] = rainbow_delimiters.strategy["global"],
			vim = rainbow_delimiters.strategy["local"],
		},
		query = {
			[""] = "rainbow-delimiters",
			lua = "rainbow-blocks",
			query = function(bufnr)
        	    local is_nofile = vim.bo[bufnr].buftype == "nofile"
        	    return is_nofile and "rainbow-blocks" or "rainbow-delimiters"
        	end

		},
		priority = {
				[""] = 110,
				lua = 210,
		},
		highlight = {
			"RainbowDelimiterRed",
			"RainbowDelimiterYellow",
			"RainbowDelimiterBlue",
			"RainbowDelimiterOrange",
			"RainbowDelimiterGreen",
			"RainbowDelimiterViolet",
			"RainbowDelimiterCyan",
		},
	}

	if config.rainbow.enabled == false then
		rainbow_delimiters.strategy = {}
		rainbow_delimiters.highlight = { "Whitespace" }
	end
end

function config.rainbow.toggle()
	config.rainbow.enabled = not config.rainbow.enabled

	config.rainbow.update()
end


function config.rainbow.init()
	require("rainbow-delimiters.setup").setup()

	config.rainbow.update()
end
-- }}}

-- {{{ ibl
function config.ibl.update()
	local highlight = {}
	local opts = {}
	if config.ibl.rainbow == true then
		highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}
	else
		highlight = { "Whitespace" }
	end

	require("ibl").setup({
		enabled = config.ibl.enabled,
		indent = {
			highlight = highlight,
			char = "▏",
			tab_char = "▏",
			smart_indent_cap = true,
		},
		whitespace = {
			highlight = highlight,
			remove_blankline_trail = false,
		},
		scope = {
			highlight = { "Whitespace" },
			enabled = true,
			char = "▍",
			show_start = false,
			show_end = false,
		},
	})
end

function config.ibl.toggle()
	config.ibl.enabled = not config.ibl.enabled

	config.ibl.update()
end

function config.ibl.toggle_rainbow()
	config.ibl.rainbow = not config.ibl.rainbow

	config.ibl.update()
end

function config.ibl.init()
	local hooks = require "ibl.hooks"
	-- create the highlight groups in the highlight setup hook, so they are reset
	-- every time the colorscheme changes
	hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
	end)
	hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

	config.ibl.update()
end
-- }}}

-- {{{ autopairs
function config.autopairs.config()
	require("nvim-autopairs").setup({})

	-- Cmp compatibility
	local cmp_autopairs = require('nvim-autopairs.completion.cmp')
	local cmp = require('cmp')
	cmp.event:on(
		'confirm_done',
		cmp_autopairs.on_confirm_done()
	)
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
            severity_limit = 'Warning',
        },
        update_in_insert = true,
    })

	require("nvim-ts-autotag").setup({})
end
-- }}}

return config
