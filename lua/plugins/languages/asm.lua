return {
	plugins = {},
	init = function()
		vim.lsp.config('asm-lsp', {
			cmd = { "asm-lsp" },
			filetypes = { "asm" },
			on_attach = function (client, bufnr)
			end,
			settings = {
			},
		})

		vim.lsp.enable('asm-lsp')
	end,
}
