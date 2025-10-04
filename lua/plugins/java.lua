return {
	{
		'nvim-java/nvim-java',
		init = function()
			require("java").setup({
				java_debug_adapter = {
					enable = false,
				},
				notifications = {
					dap = false,
				},
				jdk = {
					-- install jdk using mason.nvim
					auto_install = false,
					version = '21.0.8',
				},
				mason = {
					-- These mason registries will be prepended to the existing mason
					-- configuration
					registries = {
						'github:nvim-java/mason-registry',
					},
				},
			})
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyLoad",
				callback = function(args)
					if args.data ~= 'lspconfig' then
						return
					end
				end
			})
		end
	}
}
