packadd! nvim-lspconfig

"
lua <<EOF
require 'python-lsp'
require 'tscript-lsp'
require 'texlab-lsp'
require 'vimscript-lsp'
require 'elm-lsp'
require 'css-lsp'
require 'c-langs-lsp'
require 'rust-lsp'
require 'html-lsp'
require 'vue-lsp'
require 'init'

-- LSP Better UI
local saga = require 'lspsaga'

-- Load default options
saga.init_lsp_saga()

EOF
"
nnoremap <silent> <leader>rr <cmd>lua vim.lsp.buf.references()<CR>
" Rename function or variable
nnoremap <silent> <leader>rR :Lspsaga rename<CR>
" Show definition preview
nnoremap <silent> <leader>rp :Lspsaga preview_definition<CR>

" Show diagnosic
nnoremap <silent> <leader>re :Lspsaga show_line_diagnostics<CR>

" Diagnosics jump
nnoremap <silent> [e :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]e :Lspsaga diagnostic_jump_prev<CR>

" Show definition
nnoremap <silent> <leader>rd <cmd>lua vim.lsp.buf.definition()<CR>
" Show code action
nnoremap <silent> <leader>ra :Lspsaga code_action<CR>
" Signature help
nnoremap <silent> <leader>rs :Lspsaga signature_help<CR>

" Buffer actions
nnoremap <silent> <leader>bf <cmd>lua vim.lsp.buf.formatting()<CR>

" Show documentation
nnoremap <silent> <leader>K :Lspsaga hover_doc<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-k> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-j> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>


autocmd CursorHold *.[py] lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI *.[py] lua vim.lsp.buf.document_highlight()
autocmd CursorMoved *.[py]  lua vim.lsp.buf.clear_references()
