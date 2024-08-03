local config = {
	lspkind = {},
	cmp = {},
	endhints = {},
}

function config.lspkind.config()
	require('lspkind').init({
		-- DEPRECATED (use mode instead): enables text annotations
		--
		-- default: true
		-- with_text = true,

		-- defines how annotations are shown
		-- default: symbol
		-- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
		mode = 'symbol_text',

		-- default symbol map
		-- can be either 'default' (requires nerd-fonts font) or
		-- 'codicons' for codicon preset (requires vscode-codicons font)
		--
		-- default: 'default'
		preset = 'default',

		-- override preset symbols
		--
		-- default: {}
		symbol_map = {
			Text = "󰉿",
			Method = "󰆧",
			Function = "󰊕",
			KeywordFunction = "󰊕",
			Constructor = "",
			Field = "󰜢",
			Variable = "󰀫",
			Class = "󰠱",
			Interface = "",
			Module = "",
			Property = "󰜢",
			Unit = "󰑭",
			Value = "󰎠",
			Enum = "",
			Keyword = "󰌋",
			Snippet = "",
			Color = "󰏘",
			File = "󰈙",
			Reference = "󰈇",
			Folder = "󰉋",
			EnumMember = "",
			Constant = "󰏿",
			Boolean = ' ',
			Struct = "󰙅",
			Event = "",
			Operator = "󰆕",
			Type = ' ',
			TypeParameter = '󰆩 ',
			VariableBuiltin = '󰫧 ',
			KeywordOperator = ' ',
			VariableMember = '󱃻 ',
			Comment = ' ',
			String = ' ',
			StringEscape = '󱊷 ',
			Character = '󰾹',
			Number = '',
			KeywordType = '',
			FunctionMacro = '󰡱',
			VariableParameter = ' ',
			KeywordConditional = '󰦐 ',
			KeywordModifier = ' ',
			KeywordImport = '󰋺 ',
			TypeBuiltin = '',
			KeywordRepeat = '󰑖',
			KeywordReturn = '󰌑',
		},
	})
end

function config.cmp.config()
	local cmp = require("cmp")
	cmp.setup({
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		preselect = cmp.PreselectMode.None,
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		window = {
			completion = cmp.config.window.bordered {
				col_offset = -2,
				side_padding = 0,
				border = "none",
				winhighlight = "NormalFloat:TelescopeNormal,FloatBorder:TelescopeBorder",
			},
			documentation = cmp.config.window.bordered {
				border = "none",
				winhighlight = "NormalFloat:TelescopeNormal,FloatBorder:TelescopeBorder",
			},
		},
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 24 })(entry, vim_item)
				local strings = vim.split(kind.kind, "%s", { trimempty = true })
				kind.kind = " " .. (strings[1] or "") .. " "
				if strings[2] ~= "" then
					kind.menu = " (" .. (strings[2] or "") .. ")"
				else
					kind.menu = ""
				end


				return kind
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "path" },
			--{ name = "cmdline" },
			{ name = "treesitter" },
			{ name = "doxygen" },
		}, { name = "buffer" })
	})

	-- Set configuration for specific filetype.
	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({
			{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		}, {
			{ name = "buffer" },
		})
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" }
		}
	})

	-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" }
		}, {
			{ name = "cmdline" }
		}),
		matching = { disallow_symbol_nonprefix_matching = false }
	})

	-- Enable dap completion
	require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})
end

function config.endhints.config()
	require("lsp-endhints").setup {
		icons = {
			type = "󰜁 ",
			parameter = "󰏪 ",
			offspec = " ", -- hint kind not defined in official LSP spec
			unknown = " ", -- hint kind is nil
		},
		label = {
			padding = 1,
			marginLeft = 0,
			bracketedParameters = true,
		},
		autoEnableHints = true,
	}
end

return config
