return {
	setup = function()
		vim.lsp.config('rust-analyzer', {
			cmd = { vim.fn.expand("~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer") },
			filetypes = { "rust" },
			---@diagnostic disable-next-line: unused-local
			on_attach = function(client, bufnr)
				--require "nvim-navic".attach(client, bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					diagnostics = {
						enable = true,
						--disabled = { "unresolved-proc-macro" },
						enableExperimental = true,
					},
					procMacro = {
						enable = true,
						--ignore = { "auto_registry" },
					},
					completion = {
						addCallParenthesis = true,
						callable = {
							snippets = "fill_arguments",
						},
					},
					inlayHints = {
						bindingModeHints = {
							enable = true,
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

		vim.lsp.enable('rust-analyzer')
	end,
}
