-- Vim settings
vim.g.mapleader = " "
vim.g.completion = true

vim.o.swapfile = false
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.clipboard = "unnamedplus"
vim.o.smartindent = true
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.nu = true
vim.opt.cursorline = true
-- Color scheme
vim.cmd([[
	colorscheme catppuccin-mocha
]])

vim.api.nvim_set_hl(0, "LineNr", {
	fg = "#6c7086",
	bg = "NONE", -- Use NONE for transparent background
})

vim.api.nvim_set_hl(0, "CursorLineNr", {
	fg = "#89b4fa",
	bold = true,
})
