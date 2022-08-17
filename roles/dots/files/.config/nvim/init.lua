vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Global options
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 6
vim.o.signcolumn = 'yes'
vim.o.cursorline = true

vim.o.termguicolors = true

vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.swapfile = false

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
vim.o.cindent = true
vim.o.wrap = true
vim.o.textwidth = 300
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.softtabstop = -1 -- If negative, shiftwidth value is used
vim.o.scrolloff = 8
vim.o.list = true
vim.o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'

vim.o.clipboard = 'unnamedplus'

vim.o.ignorecase = true
vim.o.smartcase = true

-- Code folding
-- Now handled via treesitter
-- vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 99
vim.o.foldnestmax = 10
vim.o.foldignore = ''
vim.o.foldminlines = 1

require('dzager.keymaps')
require('dzager.plugins')

vim.cmd('highlight WinSeparator guibg=None')
vim.cmd('highlight SignColumn guibg=None')
vim.opt.laststatus = 3

