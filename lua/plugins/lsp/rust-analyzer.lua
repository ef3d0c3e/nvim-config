return {
	plugins = {},
	init = function()
		vim.lsp.config('rust-analyzer', {
			cmd = { "rust-analyzer" },
			filetypes = { "rust" },
			settings = {
				["rust-analyzer"] = {
					diagnostics = {
						enable = true,
						disabled = { "unresolved-proc-macro" },
						enableExperimental = true,
					},
					procMacro = {
						enable = false,
						ignored = { "auto_registry" },
					},
					completion = {
						addCallParenthesis = true,
						callable = {
							snippets = "fill_arguments",
						},
					},
					inlayHints = {
						bindingModeHints = {
							enable = false,
						},
						chainingHints = {
							enable = true,
						},
						closingBraceHints = {
							enable = true,
							minLines = 25,
						},
						closureReturnTypeHints = {
							enable = "never",
						},
						lifetimeElisionHints = {
							enable = "never",
							useParameterNames = false,
						},
						maxLength = 25,
						parameterHints = {
							enable = true,
						},
						reborrowHints = {
							enable = "never",
						},
						renderColons = true,
						typeHints = {
							enable = true,
							hideClosureInitialization = false,
							hideNamedConstructor = false,
						},
					},
				},
			},
		})
	end,
}
