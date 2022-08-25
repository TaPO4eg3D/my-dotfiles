local cmd = vim.cmd
local opt = vim.opt

vim.api.nvim_set_hl(
0,
"lCursor",
{fg="", bg="Cyan"}
)

-- Set "Dracula" colorscheme
cmd.syntax("enable")
cmd("packadd! dracula")
cmd.colorscheme("dracula")

-- Use true colors
opt.termguicolors = true
