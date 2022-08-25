local vim = vim
local api = vim.api

-- Set Leader mapping to Space
vim.g.mapleader = " "

local M = {}
-- map helper
function M.map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Mappings for FileExplorer
M.map("n", "<leader>nn", ":NvimTreeToggle<CR>")
M.map("n", "<leader>nf", ":NvimTreeFocus<CR>")
M.map("n", "<leader>nc", ":NvimTreeFindFile<CR>")

-- Buffers navigation
M.map("n", "<leader>bh", ":bp<CR>")
M.map("n", "<leader>bl", ":bl<CR>")

-- Window navigation
M.map("n", "<A-p>", "<c-w>p")
M.map("n", "<A-l>", "<c-w>l")
M.map("n", "<A-h>", "<c-w>h")
M.map("n", "<A-j>", "<c-w>j")
M.map("n", "<A-k>", "<c-w>k")
M.map("n", "<A-w>", "<c-w>w")

M.map("n", "<leader>o", ":BufExplorer<CR>")

-- Map GIT Operations
M.map("n", "<leader>gu", ":GitGutterUndoHunk<CR>")
M.map("n", "<leader>gp", ":GitGutterPreviewHunk<CR>")
M.map("n", "<leader>gP", ":Git push -u origin HEAD<CR>")
M.map("n", "<leader>gb", ":Git blame<CR>")

-- LSP Mappings

M.map("n", "<leader>rq", [[<cmd>lua vim.lsp.buf.references()<CR>]], { silent = true })
M.map("n", "<leader>rr", [[<cmd>Lspsaga lsp_finder<CR>]], { silent = true })
M.map("n", "<leader>rR", [[:Lspsaga rename<CR>]], { silent = true })
M.map("n", "<leader>rp", [[:Lspsaga preview_definition<CR>]], { silent = true })

M.map("n", "<leader>re", [[:Lspsaga show_line_diagnostics<CR>]], { silent = true })

M.map("n", "]e", [[:Lspsaga diagnostic_jump_next<CR>]], { silent = true })
M.map("n", "[e", [[:Lspsaga diagnostic_jump_prev<CR>]], { silent = true })

M.map("n", "<leader>rd", [[<cmd>lua vim.lsp.buf.definition()<CR>]], { silent = true })

M.map("n", "<leader>ra", [[:Lspsaga code_action<CR>]], { silent = true })
M.map("n", "<leader>rs", [[:Lspsaga signature_help<CR>]], { silent = true })

-- Telescope mappings

-- TODO: Return to it later, since Telescope is super slow now
-- M.map("n", "<leader>ff", [[<cmd> lua require('telescope.builtin').find_files()<CR>]])
-- M.map("n", "<leader>fi", [[<cmd> lua require('plugins.config.tscope').live_grep_no_test()<CR>]])
-- M.map("n", "<leader>fI", [[<cmd> lua require('telescope.builtin').live_grep()<CR>]])

-- FZF Mappings

M.map("n", "<leader>ff", [[:GFiles<CR>]])
M.map("n", "<leader>fF", [[:Files<CR>]])
M.map("n", "<leader>fi", [[<cmd>lua require('plugins.config.fzf').fzf_no_tests()<CR>]])
M.map("n", "<leader>fI", [[:Rg<CR>]])

-- Debuger mappings
M.map("n", "<leader>db", [[<cmd>lua require('dap').toggle_breakpoint()<CR>]])
M.map("n", "<leader>dc", [[<cmd>lua require('dap').continue()<CR>]])
M.map("n", "<leader>dn", [[<cmd>lua require('dap').step_over()<CR>]])
M.map("n", "<leader>di", [[<cmd>lua require('dap').step_into()<CR>]])
M.map("n", "<leader>du", [[<cmd>lua require('dapui').toggle()<CR>]])

return M
