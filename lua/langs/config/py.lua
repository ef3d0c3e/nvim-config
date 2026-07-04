return {
	setup = function()
		vim.lsp.config('basedpyright', {
			---@diagnostic disable-next-line: unused-local
			on_attach = function(client, bufnr)
				vim.treesitter.start(bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
			filetypes = { 'python' },
		})

		vim.lsp.enable('basedpyright')
	end
}
