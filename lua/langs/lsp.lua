return {
	{
		"neovim/nvim-lspconfig",
	},

	{
		"xzbdmw/colorful-menu.nvim",
		opts = {},
	},

	{
		"saghen/blink.cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"xzbdmw/colorful-menu.nvim",
			--{ 'L3MON4D3/LuaSnip', version = 'v2.*' },
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source
		-- build = "cargo build --release",
		-- If you use nix, you can build from source with:
		-- build = "nix run .#build-plugin",

		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = 'none',
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<C-e>'] = { 'cancel', 'fallback' },

				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active({ direction = 1 }) then
							if not cmp.is_visible() or vim.fn.mode() ~= "i" then
								return cmp.snippet_forward()
							end
						end
						return cmp.accept()
					end,
					"fallback",
				},

				["<S-Tab>"] = {
					function(cmp)
						return cmp.select_prev()
					end,
					"fallback",
				},

				["<C-CR>"] = {
					function(cmp)
						if cmp.snippet_active({ direction = 1 }) then
							return cmp.snippet_forward()
						end
					end,
					"fallback",
				},

				['<C-n>'] = {
					'snippet_forward',
					'fallback',
				},
				['<C-p>'] = {
					'snippet_backward',
					'fallback',
				},

				['<Up>'] = { 'select_prev', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },

				['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
			},

			appearance = {
				-- "mono" (default) for "Nerd Font Mono" or "normal" for "Nerd Font"
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono"
			},

			--snippets = { preset = 'luasnip' },

			completion = {
				menu = {
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},

				list = {
					selection = {
						auto_insert = function(ctx) return ctx.mode == 'cmdline' and false or true end,
					},
				},

				ghost_text = { enabled = true },
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					path = { name = 'path', score_offset = 600 },
					lsp = { name = 'lsp', score_offset = 200 },
					snippets = { name = 'snippets', score_offset = 150 },
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" }
		},
		opts_extend = { "sources.default" }
	},

	{
		'williamboman/mason.nvim',
		cmd = 'Mason',
		build = ':MasonUpdate',
		dependencies = 'nvim-lua/plenary.nvim',
		opts = { ui = { height = 0.8 } },
	},

	{
		'williamboman/mason-lspconfig.nvim',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			automatic_installation = false,
			ensure_installed = {
				'lua_ls',
			},
			handlers = {
				function(name)
					local config = require('plugins.lsp.servers')(name)
					if config then require('lspconfig')[name].setup(config) end
				end,
			},
		},
		dependencies = {
			'mason.nvim',
		},
	},
}
