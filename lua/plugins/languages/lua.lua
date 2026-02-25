return {
	plugins =
	{
	},
	init = function()
		vim.lsp.config('lua_ls', {
			on_attach = function(client, bufnr)
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end,
			cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lua-language-server" },
			filetypes = { "lua" },
			settings =
			{
				Lua =
				{
					hint =
					{
						enable = true,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							[vim.fn.expand "$VIMRUNTIME/lua"] = true,
							[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
							[vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
							[vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
						},
						maxPreload = 100000,
						preloadFileSize = 10000,
					},
				},
			},
		})

		vim.lsp.enable('lua_ls')
	end
}
