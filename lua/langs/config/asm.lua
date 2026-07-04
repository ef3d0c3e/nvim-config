return {
	setup = function()
		vim.lsp.config('asm-lsp', {
			cmd = { "asm-lsp" },
			filetypes = { "asm" },
			---@diagnostic disable-next-line: unused-local
			on_attach = function (client, bufnr)
			end,
			settings = {
			},
		})

		vim.lsp.enable('asm-lsp')
	end,
}

