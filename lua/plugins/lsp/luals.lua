return {
	init = function() 
		--vim.lsp.config('lua_ls', {
		--	cmd = { os.getenv("HOME") .. "/.local/share/nvim/mason/bin/lua-language-server" },
		--	filetypes = { "rust" },
		--	settings =
		--	{
		--		Lua =
		--		{
		--			hint =
		--			{
		--				enable = true,
		--			},
		--			diagnostics = {
		--				globals = { "vim" },
		--			},
		--			workspace = {
		--				library = {
		--					[vim.fn.expand "$VIMRUNTIME/lua"] = true,
		--					[vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
		--					[vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
		--					[vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
		--				},
		--				maxPreload = 100000,
		--				preloadFileSize = 10000,
		--			},
		--		},
		--	},
		--})
		--vim.lsp.enable('lua_ls')
	end,

	-- Auto setup lua_ls for neovim plugin developpement (also a requirement of nvim-dap-ui)
	plugins = {
		{
			"folke/neodev.nvim",
			opts = {}
		},
	},

}
