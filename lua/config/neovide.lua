if not vim.g.neovide then
	return
end

vim.api.nvim_set_keymap('v', '<sc-c>', '"+y', {noremap = true})
vim.api.nvim_set_keymap('n', '<sc-v>', 'l"+P', {noremap = true})
vim.api.nvim_set_keymap('v', '<sc-v>', '"+P', {noremap = true})
vim.api.nvim_set_keymap('c', '<sc-v>', '<C-o>l<C-o>"+<C-o>P<C-o>l', {noremap = true})
vim.api.nvim_set_keymap('i', '<sc-v>', '<ESC>l"+Pli', {noremap = true})
vim.api.nvim_set_keymap('t', '<sc-v>', '<C-\\><C-n>"+Pi', {noremap = true})
vim.o.guifont = "IosevkaTerm Nerd Font:h12:#e-subpixelantialias:#h-full" -- text below applies for VimScript
vim.g.neovide_confirm_quit = true
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0.00
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_scroll_animation_length = 0.0
vim.g.neovide_opacity = 0.9
vim.g.neovide_normal_opacity = 0.15
vim.cmd("hi Normal guibg=#1f1f1f")

vim.g.neovide_floating_blur_amount_x = 1.0
vim.g.neovide_floating_blur_amount_y = 1.0

vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 0
vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

vim.g.neovide_floating_corner_radius = 0.3
