-- Mode colors for modes and lualine
local mode_colors = {
	normal = "#7fB070",
	replace = "#Df8040",
	copy = "#f5c359",
	delete = "#c75c6a",
	insert = "#78ccc5",
	visual = "#9745be",
}

local config = {
	-- {{{ which-key
	which_key = {
		preset = "modern",
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = "+", -- symbol prepended to a group
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "left", -- align columns left, center or right
		},
		show_help = true, -- show a help message in the command line for using WhichKey
		show_keys = true, -- show the currently pressed key and its label as a message in the command line
		disable = {
			buftypes = {},
			filetypes = {},
		},
	}, -- }}}

	stickybuf = {},

	telescope = {},

	-- {{{ dressing
	dressing = {
		input = {
			-- Set to false to disable the vim.ui.input implementation
			enabled = true,

			-- Default prompt string
			default_prompt = "Input",

			-- Trim trailing `:` from prompt
			trim_prompt = true,

			-- Can be 'left', 'right', or 'center'
			title_pos = "left",

			-- When true, <Esc> will close the modal
			insert_only = true,

			-- When true, input will start in insert mode.
			start_in_insert = true,

			-- These are passed to nvim_open_win
			border = "rounded",
			-- 'editor' and 'win' will default to being centered
			relative = "cursor",

			-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			prefer_width = 40,
			width = nil,
			-- min_width and max_width can be a list of mixed types.
			-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
			max_width = { 140, 0.9 },
			min_width = { 20, 0.2 },

			buf_options = {},
			win_options = {
				-- Disable line wrapping
				wrap = false,
				-- Indicator for when text exceeds window
				list = true,
				listchars = "precedes:…,extends:…",
				-- Increase this for more context when text scrolls off the window
				sidescrolloff = 0,
			},

			-- Set to `false` to disable
			mappings = {
				n = {
					["<Esc>"] = "Close",
					["<CR>"] = "Confirm",
				},
				i = {
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
					["<Up>"] = "HistoryPrev",
					["<Down>"] = "HistoryNext",
				},
			},

			override = function(conf)
				-- This is the config that will be passed to nvim_open_win.
				-- Change values here to customize the layout
				return conf
			end,

			-- see :help dressing_get_config
			get_config = nil,
		},
		select = {
			-- Set to false to disable the vim.ui.select implementation
			enabled = true,

			-- Priority list of preferred vim.select implementations
			backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

			-- Trim trailing `:` from prompt
			trim_prompt = true,

			-- Options for telescope selector
			-- These are passed into the telescope picker directly. Can be used like:
			-- telescope = require('telescope.themes').get_ivy({...})
			telescope = nil,

			-- Options for fzf selector
			fzf = {
				window = {
					width = 0.5,
					height = 0.4,
				},
			},

			-- Options for fzf-lua
			fzf_lua = {
				-- winopts = {
				--	 height = 0.5,
				--	 width = 0.5,
				-- },
			},

			-- Options for nui Menu
			nui = {
				position = "50%",
				size = nil,
				relative = "editor",
				border = {
					style = "rounded",
				},
				buf_options = {
					swapfile = false,
					filetype = "DressingSelect",
				},
				win_options = {
					winblend = 0,
				},
				max_width = 80,
				max_height = 40,
				min_width = 40,
				min_height = 10,
			},

			-- Options for built-in selector
			builtin = {
				-- Display numbers for options and set up keymaps
				show_numbers = true,
				-- These are passed to nvim_open_win
				border = "rounded",
				-- 'editor' and 'win' will default to being centered
				relative = "editor",

				buf_options = {},
				win_options = {
					cursorline = true,
					cursorlineopt = "both",
				},

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				-- the min_ and max_ options can be a list of mixed types.
				-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
				width = nil,
				max_width = { 140, 0.8 },
				min_width = { 40, 0.2 },
				height = nil,
				max_height = 0.9,
				min_height = { 10, 0.2 },

				-- Set to `false` to disable
				mappings = {
					["<Esc>"] = "Close",
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
				},

				override = function(conf)
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					return conf
				end,
			},

			-- Used to override format_item. See :help dressing-format
			format_item_override = {},

			-- see :help dressing_get_config
			get_config = nil,
		},
	}, -- }}}

	neo_tree = {},

	bufferline = {},

	dropbar = {},

	-- {{{ modes
	modes = {
		colors = mode_colors,

		-- Set opacity for cursorline and number background
		line_opacity = 0.30,

		-- Enable cursor highlights
		set_cursor = true,

		-- Enable cursorline initially, and disable cursorline for inactive windows
		-- or ignored filetypes
		set_cursorline = true,

		-- Enable line number highlights to match cursorline
		set_number = true,

		-- Disable modes highlights in specified filetypes
		-- Please PR commonly ignored filetypes
		ignore_filetypes = { 'neo-tree', 'TelescopePrompt' }
	}, -- }}}

	lualine = {},

	noice = {},

	toggleterm = {},

	statuscol = {},

	startup = {},
}

-- {{{ telescope
function config.telescope.init()
	local TelescopePrompt = {
	    TelescopeNormal = {
	        bg = "#1F2335",
	    },
	    TelescopePromptNormal = {
	        bg = "#2d3149",
	    },
	    TelescopePromptBorder = {
	        bg = "#2d3149",
	        fg = "#2d3149",
	    },
	    TelescopePromptTitle = {
	        bg = "#2A2A2A",
			fg = "#F0F0F0",
	    },
	    TelescopePreviewTitle = {
	        fg = "#1F2335",
	        bg = "#1F2335",
	    },
	    TelescopeResultsTitle = {
	        bg = "#1F2335",
	    },
		TelescopeBorder = {
	        bg = "#1F2335",
	        fg = "#1F2335",
		},
	}
	for hl, col in pairs(TelescopePrompt) do
	    vim.api.nvim_set_hl(0, hl, col)
	end

	local telescope = require("telescope")
	telescope.setup({
		defaults = {
			-- Default configuration for telescope goes here:
			-- config_key = value,
			mappings = {
				i = {
					-- map actions.which_key to <C-h> (default: <C-/>)
					-- actions.which_key shows the mappings for your picker,
					-- e.g. git_{create, delete, ...}_branch for the git_branches picker
					["<C-h>"] = "which_key"
				}
			}
		},
		pickers = {
			-- Default configuration for builtin pickers goes here:
			-- picker_name = {
			--	 picker_config_key = value,
			--	 ...
			-- }
			-- Now the picker_config_key will be applied every time you call this
			-- builtin picker
		},
		extensions = {
			-- Your extension configuration goes here:
			-- extension_name = {
			--	 extension_config_key = value,
			-- }
			-- please take a look at the readme of the extension you want to configure
		}
	})
	
	-- Extensions
	telescope.load_extension('notify')
	--telescope.load_extension('dap')
end
-- }}}

-- {{{ neo-tree
function config.neo_tree.init()
	--require("window-picker").setup()

	require("neo-tree").setup({
		open_files_do_not_replace_types = { "terminal", "Trouble", "qf" },
		close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
		enable_git_status = true,
		enable_diagnostics = true,
		source_selector = {
			sources = {
				{ source = "filesystem" },
				{ source = "git_status" },
				{ source = "buffers" },
				{ source = "document_symbols" },
			},
		},
		document_symbols = {
			follow_cursor = true,
			renderers = {
				symbol = {
					{ "indent", with_expanders = true },
					{ "kind_icon", default = "?" },
					{ "name", zindex = 10 },
					-- removed the kind text as its redundant with the icon
				},
			},
		},
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1, -- extra padding on left hand side
				-- indent guides
				with_markers = true,
				-- indent_marker = "│",
				-- last_indent_marker = "└",-- └
				indent_marker = "▏",
				last_indent_marker = "▏",
				highlight = "NeoTreeIndentMarker",
				-- expander config, needed for nesting files
				with_expanders = false, -- if nil and file nesting is enabled, will enable expanders
				-- expander_collapsed = "",
				-- expander_expanded = "",

				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				-- folder_closed = "",
				-- folder_open = "",
				-- folder_closed = " ",
				-- folder_open = " ",
				folder_empty = "",
				default = " ",
				highlight = "NeoTreeFileIcon",
			},
			modified = {
				symbol = " ",
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					-- Change type
					added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
					modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
					deleted = "", -- this can only be used in the git_status source
					renamed = "", -- this can only be used in the git_status source
					-- Status type
					untracked = "",
					ignored = "",
					-- unstaged = "",
					unstaged = "U",
					staged = "",
					conflict = "",
				},
			},
		},
		window = {
			position = "float",
			width = 40,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
				},
				["<1-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["l"] = "open",
				["S"] = "open_split",
				["s"] = "open_vsplit",
				-- ["S"] = "split_with_window_picker",
				-- ["s"] = "vsplit_with_window_picker",
				["t"] = "open_tabnew",
				["w"] = "open_with_window_picker",
				["C"] = "close_node",
				["a"] = {
					"add",
					-- some commands may take optional config options, see `:h neo-tree-mappings` for details
					config = {
						show_path = "none", -- "none", "relative", "absolute"
					},
				},
				["A"] = "add_directory", -- also accepts the config.show_path option.
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy", -- takes text input for destination
				["m"] = "move", -- takes text input for destination
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
			},
		},
		nesting_rules = {
			-- ["js"] = { "js.map" },
		},
		filesystem = {
			filtered_items = {
				visible = false, -- when true, they will just be displayed differently than normal items
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_by_name = {
					--"node_modules"
				},
				hide_by_pattern = { -- uses glob style patterns
					--"*.meta"
				},
				never_show = { -- remains hidden even if visible is toggled to true
					--".DS_Store",
					--"thumbs.db"
				},
			},
			follow_current_file = {
				enabled = true, -- This will find and focus the file in the active buffer every
			},
			-- time the current file is changed while the tree is open.
			group_empty_dirs = false, -- when true, empty folders will be grouped together
			hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
			-- in whatever position is specified in window.position
			-- "open_current",  -- netrw disabled, opening a directory opens within the
			-- window like netrw would, regardless of window.position
			-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
			use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
			-- instead of relying on nvim autocmd events.
			window = {
				mappings = {
					["H"] = "navigate_up",
					["<bs>"] = "toggle_hidden",
					["."] = "set_root",
					["/"] = "fuzzy_finder",
					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
				},
			},
		},
		buffers = {
			follow_current_file = {
				enabled = true, -- This will find and focus the file in the active buffer every
			},
			-- time the current file is changed while the tree is open.
			group_empty_dirs = true, -- when true, empty folders will be grouped together
			show_unloaded = true,
			window = {
				mappings = {
					["bd"] = "buffer_delete",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
				},
			},
		},
		git_status = {
			window = {
				position = "float",
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
				},
			},
		},
		renderers = {
			directory = {
				{ "indent" },
				{ "icon" },
				{ "current_filter" },
				{
					"container",
					content = {
						{ "name",      zindex = 10 },
						-- {
							--   "symlink_target",
							--   zindex = 10,
							--   highlight = "NeoTreeSymbolicLinkTarget",
							-- },
							{ "clipboard", zindex = 10 },
							{
								"diagnostics",
								errors_only = true,
								zindex = 20,
								align = "right",
								hide_when_expanded = false,
							},
							{
								"git_status",
								zindex = 10,
								align = "right",
								hide_when_expanded = true,
							},
						},
					},
				},
				file = {
					{ "indent" },
					{ "icon" },
					{
						"container",
						content = {
							{
								"name",
								zindex = 10,
							},
							-- {
								--   "symlink_target",
								--   zindex = 10,
								--   highlight = "NeoTreeSymbolicLinkTarget",
								-- },
								{ "clipboard",   zindex = 10 },
								{ "bufnr",       zindex = 10 },
								{ "modified",    zindex = 20, align = "right" },
								{ "diagnostics", zindex = 20, align = "right" },
								{ "git_status",  zindex = 15, align = "right" },
							},
						},
					},
					message = {
						{ "indent", with_markers = false },
						{ "name",   highlight = "NeoTreeMessage" },
					},
					terminal = {
						{ "indent" },
						{ "icon" },
						{ "name" },
						{ "bufnr" },
					},
				},
	})
end
-- }}}

-- {{{ bufferline
function config.bufferline.config()
    local bufferline = require("bufferline")
    bufferline.setup({
        options = {
            mode = "buffers", -- set to "tabs" to only show tabpages instead
            style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
            themable = false, -- allows highlight groups to be overriden i.e. sets highlights as default
            numbers = "none",
            close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
            right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
            left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
            middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
            indicator = {
                icon = '▎', -- this should be omitted if indicator style is not 'icon'
                style = 'icon',
            },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            --- name_formatter can be used to change the buffer's label in the bufferline.
            --- Please note some names can/will break the
            --- bufferline so use this at your discretion knowing that it has
            --- some limitations that will *NOT* be fixed.
            --name_formatter = function(buf)  -- buf contains:
            --      -- name                | str        | the basename of the active file
            --      -- path                | str        | the full path of the active file
            --      -- bufnr (buffer only) | int        | the number of the active buffer
            --      -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
            --      -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
            --end,
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            truncate_names = true, -- whether or not tab names should be truncated
            tab_size = 18,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                return "("..count..")"
            end,
            -- NOTE: this will be called a lot so don't do any heavy processing here
            custom_filter = function(buf_number, buf_numbers)
				return true
                ---- filter out filetypes you don't want to see
                --if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                --    return true
                --end
                ---- filter out by buffer name
                --if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                --    return true
                --end
                ---- filter out based on arbitrary rules
                ---- e.g. filter out vim wiki buffer from tabline in your work repo
                --if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                --    return true
                --end
                ---- filter out by it's index number in list (don't show first buffer)
                --if buf_numbers[1] ~= buf_number then
                ----    return true
                --end
            end,
            color_icons = true,
            get_element_icon = function(element)
              -- element consists of {filetype: string, path: string, extension: string, directory: string}
              -- This can be used to change how bufferline fetches the icon
              -- for an element e.g. a buffer or a tab.
              -- e.g.
              local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
              return icon, hl
            end,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = false,
            show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
            duplicates_across_groups = true, -- whether to consider duplicate paths in different groups as duplicates
            persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
            move_wraps_at_ends = true, -- whether or not the move command "wraps" at the first or last position
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { '|', '|' }
            separator_style = 'thick',
			--"slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
            enforce_regular_tabs = true,
            always_show_bufferline = true,
            auto_toggle_bufferline = true,
            hover = {
                enabled = false,
                delay = 200,
                reveal = {'close'}
            },
            --sort_by = 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
            --    -- add custom logic
            --    return buffer_a.modified > buffer_b.modified
            --end
        },
		highlights = {
			indicator_selected = {
				fg = {
					attribute = 'fg',
					highlight = 'Namespace'
				},
			},
		},
    })
end
-- }}}

-- {{{ dropbar
function config.dropbar.config()
	require "dropbar".setup({
		bar = {
			enable = function(buf, win, _)
				return vim.api.nvim_buf_is_valid(buf)
				and vim.api.nvim_win_is_valid(win)
				and vim.wo[win].winbar == ''
				and (
				(pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft)) and true
				or false
				)
			end,
			attach_events = {
				'OptionSet',
				'BufWinEnter',
				'BufWritePost',
			},
		},
	})
end
-- }}}

-- {{{ lualine
function config.lualine.config()
	local ppp = require("lush_theme.ppp")
	local colors = {
		bg = ppp.LualineNormal.bg.hex,
		fg = ppp.LualineNormal.fg.hex,
		accent = ppp.LualineAccent.bg.hex,
		black = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "EndOfBuffer", link = false }).fg),
		white = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg),
		red = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "Error", link = false }).fg),
		green = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "String", link = false }).fg),
		blue = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "Question", link = false }).fg),
		yellow = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "Type", link = false }).fg),
		cyan = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "Keyword", link = false }).fg),
		orange = string.format('#%06x', vim.api.nvim_get_hl(0, { name = "Title", link = false }).fg),
	}


	local filename_with_icon = require("lualine.components.filename"):extend()
	filename_with_icon.apply_icon = require("lualine.components.filetype").apply_icon
	filename_with_icon.icon_hl_cache = {}

	local function shorten_path(path, sep)
		-- ('([^/])[^/]+%/', '%1/', 1)
		return path:gsub(string.format("([^%s])[^%s]+%%%s", sep, sep, sep), "%1" .. sep, 1)
	end

	local function count(base, pattern)
		return select(2, string.gsub(base, pattern, ""))
	end

	local default_options = {
		symbols = { modified = "", readonly = "󰌾", unnamed = "[No Name]" },
		file_status = true,
		path = 0,
		shorting_target = 40,
	}

	local conditions = {
		buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end,
		hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end,
		check_git_workspace = function()
			local filepath = vim.fn.expand("%:p:h")
			local gitdir = vim.fn.finddir(".git", filepath .. ";")
			return gitdir and #gitdir > 0 and #gitdir < #filepath
		end,
	}

	local options = vim.tbl_deep_extend("keep", {}, default_options)

	require "lualine".setup {
		options = {
			icons_enabled = true,
			component_separators = { left = '', right = '' },
			section_separators = { left = '', right = '' },
			disabled_filetypes = {
				statusline = { "alpha" },
				winbar = { "alpha", "toggleterm", "Trouble", "spectre_panel", "qf", "noice", "dbui" },
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
			theme = {
				normal = {
					a = {bg = colors.bg, fg = colors.fg},
					b = {bg = colors.bg, fg = colors.fg},
					c = {bg = colors.bg, fg = colors.fg}
				},
			},
		},
		extension = {
			"mason",
			"lazy",
			"neo-tree",
			-- "oil",
			"quickfix",
			"toggleterm",
			"trouble",
		},
		sections = {
			-- Folder + File
			lualine_a = {
				{
					function()
						local dir = vim.fn.expand("%:p:h")

						if dir == vim.fn.getcwd() then
							return " Root"
						else
							local windwidth = options.globalstatus and vim.go.columns or vim.fn.winwidth(0)
							local estimated_space_available = windwidth - options.shorting_target

							local data = vim.fn.fnamemodify(dir, ":~:.")
							for _ = 0, count(data, "/") do
								if windwidth <= 84 or #data > estimated_space_available then
									data = shorten_path(data, "/")
								end
							end

							return " " .. data
						end
					end,
					cond = conditions.buffer_not_empty,
					color = { fg = colors.accent, bg = colors.bg }
				},
				{
					'filename',
					symbols = { modified = "", readonly = "󰌾", unnamed = "[No Name]" },
					file_status = true,
					path = 0,
					shorting_target = 40,
					cond = conditions.buffer_not_empty,
					colored = true,
					color = function()
						return { fg = "#aF70bF", gui='bold' }
					end,
				},
			},
			-- Git
			lualine_b = {
				{
					'b:gitsigns_head',
					icon ='󰘬',
					color = {
						bg = colors.bg,
						fg = "#2f74af",
					}
				},
				{
					'diff',
					symbols = { added = " ", modified = " ", removed = " " },
					diff_color = {
						added = { fg = colors.green },
						modified = { fg = colors.orange },
						removed = { fg = colors.red },
					},
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
					on_click = function()
						vim.cmd("DiffviewOpen")
					end,
					color = { bg = colors.bg }
				},
			},
			lualine_c = {},
			lualine_x = {
				{
					function() return require("noice").api.status.command.get() end,
					cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
					color = {bg = colors.teal , fg = colors.bg, gui='bold' }
				},
				{
					function() return require("noice").api.status.mode.get() end,
					cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
					color = {bg = colors.orange, fg = colors.bg, gui='bold' }
				},
				{
					"diagnostics",
					update_in_insert = true,
					symbols = { error = " ", warn = " ", info = " " },
					diagnostics_color = { -- TODO: Not working...
						color_error = { fg = ppp.LualineDiagError.fg.hex },
						color_warn = { fg = ppp.LualineDiagWarn.fg.hex },
						color_info = { fg = ppp.LualineDiagInfo.fg.hex },
					},
					color = { bg = colors.bg }
				},
				{
					function()
						local lsps = vim.lsp.get_active_clients({ bufnr = vim.fn.bufnr() })
						local icon = require("nvim-web-devicons").get_icon_by_filetype(
							vim.api.nvim_buf_get_option(0, "filetype")
						)
						if lsps and #lsps > 0 then
							local names = {}
							for _, lsp in ipairs(lsps) do
								table.insert(names, lsp.name)
							end
							return string.format("%s %s", table.concat(names, ", "), icon)
						else
							return icon or ""
						end
					end,
					on_click = function()
						vim.api.nvim_command("LspInfo")
					end,
				},
			},
			lualine_y = {
				{
					"fileformat",
					symbols = {
						unix = '', -- e712
						dos = '󰍲',	-- e70f
						mac = '',	-- e711
					},
					color = { fg = colors.orange, gui='bold' },
				},
				{
					"encoding",
					fmt = string.upper,
					color = { fg = colors.blue, gui='bold' },
				},
			},
			lualine_z = {
				{
					function()
						return "󰕭"
					end,
					color = { fg = colors.yellow, gui='bold' },
				},
				{
					"location",
				},
				{
					"selectioncount",
				},
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {}
	}
end
-- }}}

-- {{{ noice
function config.noice.config()
	local ppp = require("lush_theme.ppp")

	require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})
end
-- }}}

-- {{{ toggleterm
function config.toggleterm.config()
	require("toggleterm").setup({
		size = 20,
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = 0.1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
		start_in_insert = true,
		persist_size = true,
		direction = "horizontal",
		close_on_exit = true,
		float_opts = {
			border = { "┏", "━", "┓", "┃", "┛","━", "┗", "┃" },
		},
	})
end
-- }}}

-- {{{ statuscol
function config.statuscol.config()
	require("statuscol").setup({
		-- configuration goes here, for example:
		-- relculright = true,
		-- segments = {
		--	 { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
		--	 {
		--		 sign = { name = { "Diagnostic" }, maxwidth = 2, auto = true },
		--		 click = "v:lua.ScSa"
		--	 },
		--	 { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
		--	 {
		--		 sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
		--		 click = "v:lua.ScSa"
		--	 },
		-- }
	})
end
-- }}}

-- {{{ startup
function config.startup.config()
	require("startup").setup({
		theme = "dashboard",
	})
end
-- }}}

return config
