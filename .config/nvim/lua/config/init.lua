-- Leader key
vim.g.mapleader = " "

local opt = vim.opt

-- Sync with the system clipboard
opt.clipboard = "unnamedplus"

-- Global tab sizing
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true  -- Always use spaces insteqad of tab chars
opt.softtabstop = 4

-- Relative line numbers
opt.nu = true
opt.rnu = true

opt.termguicolors = true -- True color support

opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current

opt.swapfile = false
opt.backup = false
-- opt.wrap = false -- Disable line wrap

-- Folding
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
-- INFO: queries/rust/folds.scm
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
