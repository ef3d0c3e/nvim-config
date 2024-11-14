local opt = vim.opt

vim.opt.background = 'dark'
vim.opt.termguicolors = true

-- Copy/Pasting
opt.backupcopy = 'yes'
opt.clipboard = "unnamedplus"

-- Tabs
opt.expandtab = false
opt.smartindent = false
opt.tabstop = 4
opt.shiftwidth = 0 -- 0 To use opt.tabstop
opt.softtabstop = 0 -- 0 To use opt.tabstop
vim.cmd("let g:rust_recommended_style = 0")

vim.filetype.add({
	pattern = {
		['.*%.nml'] = 'nml',
	},
})


-- Search/Replace
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Trailing chars
opt.list = true
opt.listchars = {trail = '·', tab = '  '}

-- Writing
opt.undolevels = 10000

-- Faster re [TODO Set to 1 for fast]
opt.re = 0

-- Numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- disable nvim intro
opt.shortmess:append "sI"

-- Ui
--opt.signcolumn = 'yes:1' -- Adds padding
opt.splitbelow = true
opt.splitright = true
opt.showmode = false
opt.hidden = true
opt.wrapscan = true
opt.backup = false
opt.writebackup = false
opt.showcmd = true
opt.showmatch = true
opt.errorbells = false
opt.joinspaces = false
opt.title = true
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5 -- Minimum window width

opt.timeoutlen = 400
opt.undofile = true
-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Completion
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.wildmode = "longest:full,full" -- Command-line completion mode
-- opt.wrap = false -- Disable line wrap

-- Encoding/Formatting
opt.encoding = 'UTF-8'
opt.fileformat = 'unix'

-- Globals
opt.mouse = 'a'

vim.g.autoformat = true
vim.opt.fillchars = {
	fold = " ",
	foldopen = "",
	foldclose = "",
	foldsep = " ",
	diff = "╱",
	eob = " ",
	horiz     = '─',
	horizup   = '┴',
	horizdown = '┬',
	vert      = '│',
	vertleft  = '┤',
	vertright = '├',
	verthoriz = '┼',
}

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = ' ',
			[vim.diagnostic.severity.WARN] = ' ',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '󰌵',
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = 'ErrorMsg',
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = 'WarningMsg',
		},
	},
})

-- Folds
opt.autowrite = true -- Enable auto write
opt.foldnestmax = 4
opt.foldlevel = 1
opt.foldcolumn = "auto"
opt.foldexpr = "nvim_treesitter#foldexpr()"
--opt.foldmethod = "expr"
opt.foldmethod = "marker"
opt.foldlevelstart = 0
opt.foldenable = true

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Custom terminal",
	callback = function(args)
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.api.nvim_set_keymap("t", "<Esc><Esc>", "<c-\\><c-n><Cr>", {})
	end
})
