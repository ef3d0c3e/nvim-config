return {
	plugins = {},
	init = function()
		vim.lsp.config('r-languageserver', {
			cmd = { "r-languageserver" },
			filetypes = { "R" },
			on_attach = function (client, bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
			settings = {
			},
		})

		vim.lsp.enable('r-languageserver')
	end,
}
