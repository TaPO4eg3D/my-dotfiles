packadd! nvim-lspconfig

lua <<EOF
require 'python-lsp'
require 'tscript-lsp'
require 'texlab-lsp'
require 'vimscript-lsp'

-- Handling NVIM-LSP action through nvim-lsputil plugin
vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
EOF
"
nnoremap <silent> <leader>rr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>rR <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>rd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>rD <cmd>lua vim.lsp.buf.declaration()<CR>

nnoremap <silent> <leader>rT <cmd>lua vim.lsp.buf.type_definition()<CR>

nnoremap <silent> <leader>ra <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>bf <cmd>lua vim.lsp.buf.formatting()<CR>

" Show documentation
nnoremap <silent> <leader>K <cmd>lua vim.lsp.buf.hover()<CR>


autocmd CursorHold *.[py] lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI *.[py] lua vim.lsp.buf.document_highlight()
autocmd CursorMoved *.[py]  lua vim.lsp.buf.clear_references()


" ==== COMPLETION ==== "

" Manually trigger completion
imap <silent> <C-Space> <Plug>(completion_trigger)
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
