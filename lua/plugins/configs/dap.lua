return {
config = function()
	local mason_dap = require("mason-nvim-dap")
	mason_dap.setup({
		ensure_installed = {
			"codelldb",
			"gdb",
			"cpptools",
		},
		handlers = {
			function(config)
				-- all sources with no handler get passed here

				-- Keep original functionality
				require('mason-nvim-dap').default_setup(config)
			end,
			python = function(config)
				config.adapters = {
					type = "executable",
					command = "/usr/bin/python3",
					args = {
						"-m",
						"debugpy.adapter",
					},
				}
				require('mason-nvim-dap').default_setup(config) -- don't forget this!
			end,
		},
	})

	local dap = require("dap")

	dap.defaults.fallback.external_terminal = {
		command = 'wezterm';
		args = {'-e'};
	}


	dap.adapters.gdb = {
		type = "executable",
		command = "gdb",
		args = { "--quiet", "--interpreter=dap" }
	}
	dap.adapters.cpptools = {
		id = "cpptools",
		type = "executable",
		command = "/absolute/path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
	}
	dap.configurations.c = {
		{
			name = "Run program (GDB)",
			type = "gdb",
			request = "launch",
			program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = "${workspaceFolder}",
			stopAtBeginningOfMainSubprogram = false,
		},
		{
			name = 'Run program with arguments (GDB)',
			type = 'gdb',
			request = 'launch',
			program = function()
				return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			args = function()
				local args_str = vim.fn.input({
					prompt = 'Arguments: ',
				})
				return vim.split(args_str, ' +')
			end,
		},
		{
			name = 'Attach to process (GDB)',
			type = 'gdb',
			request = 'attach',
			processId = require('dap.utils').pick_process,
		},
	}

	require("nvim-dap-virtual-text").setup({
		enabled = true,                        -- enable this plugin (the default)
		enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
		highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
		highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
		show_stop_reason = true,               -- show stop reason when stopped for exceptions
		commented = false,                     -- prefix virtual text with comment string
		only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
		all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
		clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
		display_callback = function(variable, buf, stackframe, node, options)
		  if options.virt_text_pos == 'inline' then
			return ' = ' .. variable.value
		  else
			return variable.name .. ' = ' .. variable.value
		  end
		end,
		-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
		virt_text_pos = 'inline',

		-- experimental features:
		all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
		virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
		virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
										   -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
	})

	require("dapui").setup()


	vim.fn.sign_define('DapBreakpoint', {text='', texthl='error', linehl='', numhl=''})
end,
}
