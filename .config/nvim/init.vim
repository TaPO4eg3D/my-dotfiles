set nocompatible              " be iMproved, required
filetype plugin on

function! ChangeKeyboardLayout()
  let l:current_layout = &iminsert

  if l:current_layout == 0
    set iminsert=1
  else
    set iminsert=0
  endif

endfunction

" Russian keyboard fix
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan
noremap <silent> <C-l> :call ChangeKeyboardLayout()<CR>
inoremap <silent><expr> <C-l> ChangeKeyboardLayout()

packadd minpac
call minpac#init()

" ======================================================================
" Plugins START
" ======================================================================
" Emmet we all know and love
call minpac#add('mattn/emmet-vim')
" That fancy line that show lots of info about our current state
call minpac#add('bling/vim-airline')
" Work with 'surroundings': parentheses, brackets, quotes and so on
call minpac#add('tpope/vim-surround')
" Very powerfull plugin for working with Git
call minpac#add('tpope/vim-fugitive')
" Magit clone for VIM
call minpac#add('jreybert/vimagit')
" Support for the 'dot' command for plugins such as vim-surround and so on
call minpac#add('tpope/vim-repeat')
" Fuzzy Search
call minpac#add('junegunn/fzf')
call minpac#add('junegunn/fzf.vim')
" Support for SCSS syntax
call minpac#add('cakebaker/scss-syntax.vim')
" Nice looking VIM Theme
call minpac#add('dracula/vim', {'name': 'dracula'})
call minpac#add('tpope/vim-commentary')
call minpac#add('jlanzarotta/bufexplorer')
call minpac#add('raimondi/delimitmate')
" Support for LaTeX
call minpac#add('lervag/vimtex')
" Support for Elixir
call minpac#add('elixir-editors/vim-elixir')
" Add markdown support
call minpac#add('godlygeek/tabular')
call minpac#add('plasticboy/vim-markdown')

" NeoVIM LSP
call minpac#add('neovim/nvim-lspconfig')
" Better NeoVIM LSP UI
call minpac#add('tami5/lspsaga.nvim')
" NeoVIM Completion
call minpac#add('ms-jpq/coq_nvim')

" Highlight colors right in the vim
call minpac#add('lilydjwg/colorizer')
" Support for PUG files
call minpac#add('digitaltoad/vim-pug')
" Support for TypeScript
call minpac#add('leafgarland/typescript-vim')
" Shows Git info
call minpac#add('airblade/vim-gitgutter')
" Debugger for VIM
call minpac#add('puremourning/vimspector')
" File manager
call minpac#add('kyazdani42/nvim-web-devicons') " for file icons
call minpac#add('kyazdani42/nvim-tree.lua')
" VIM DevIcons
call minpac#add('ryanoasis/vim-devicons')
" Automatic tag management
call minpac#add('ludovicchabant/vim-gutentags')
" VimWiki
call minpac#add('vimwiki/vimwiki')
" Zettelkasten
call minpac#add('michal-h21/vim-zettel')
" Writing tables in markup languages like Markdown becomes really easy
call minpac#add('dhruvasagar/vim-table-mode')
" Support for discord rich presence, just for lulz
call minpac#add('vimsence/vimsence')
" Support of Vue.js syntax highlighting
call minpac#add('posva/vim-vue')
" Support of Treesitter
call minpac#add('nvim-treesitter/nvim-treesitter')
call minpac#add('nvim-treesitter/playground')
" ======================================================================
" Plugins END
" ======================================================================


" ======================================================================
" Common keymaps START
" ======================================================================
" Put your non-Plugin stuff after this line
let mapleader = "\<Space>"

"Toggle FileExplorer
lua << EOF
require'nvim-tree'.setup()
EOF

nnoremap <leader>nn :NvimTreeToggle<CR>
nnoremap <leader>nf :NvimTreeFocus<CR>
nnoremap <leader>nc :NvimTreeFindFile<CR>

" Convert tabs to spaces when press F9
map <F9> :%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<CR>

" Search for files
nnoremap <leader>fF :Files<cr>
" Search for project files
nnoremap <leader>ff :GFiles<cr>
" Search inside of files
nnoremap <leader>fi :Ag<cr>

" fzf tags
nmap <leader>fT :Tags<CR>
nmap <leader>ft :BTags<CR>

" Buffer navigation
nmap <leader>bh :bp<CR>
nmap <leader>bl :bn<CR>

" Window navigation
nmap <leader>wl <c-w>l
nmap <leader>wh <c-w>h
nmap <leader>wj <c-w>j
nmap <leader>wk <c-w>k
nmap <leader>ww <c-w>w

" ======================================================================
" Common keymaps END
" ======================================================================


" ======================================================================
" Common settings START
" ======================================================================
" Display number of lines
set nu rnu

" Disable swap
set noswapfile

" Set tab size
set sts=2
set ts=2
set sw=2

" Set up highlight for .ejs files
au BufNewFile,BufRead *.ejs set filetype=html

" Open buffer explorer
" TODO: Remove BufExplorer
map <leader>o :BufExplorer<cr>

" Searching tweaks
set ignorecase
set hlsearch
set smartcase
" Search immediately as you type
set incsearch

" Disable annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Use spaces instead of tabs
set expandtab

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Mouse support
set mouse=a

set updatetime=300                      " Faster completion
set clipboard+=unnamedplus               " Copy paste between vim and everything else

" ======================================================================
" Common settings END
" ======================================================================


" ======================================================================
" Style settings START
" ======================================================================
" Airline plugin setup
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Syntax and theme setup
syntax enable

packadd! dracula
colorscheme dracula

" True colors
set termguicolors
hi Normal guibg=NONE ctermbg=NONE


" ======================================================================
" Style settings START
" ======================================================================

" ======================================================================
" Latex setup START
" ======================================================================

let g:tex_flavor = 'latex'
" Hide vim-tex QuickFix window
let g:vimtex_quickfix_mode = 0

" Navigate by visual lines in TeX files
au FileType tex noremap <buffer> j gj
au FileType tex noremap <buffer> k gk

" Key bindings
au FileType tex nmap <leader>lg <Plug>(vimtex-log)
au FileType tex nmap <leader>c :VimtexCompile<CR>

" ======================================================================
" Latex setup END
" ======================================================================

" ======================================================================
" Python specific settings START
" ======================================================================

au BufRead,BufNewFile *.py highlight ColorColumn ctermbg=magenta
au BufRead,BufNewFile *.py call matchadd('ColorColumn', '\%121v', 100)

" Generate python excluding common env folders TODO: it should be managed by Gutentags, figure out this later
au BufRead,BufNewFile *.py let g:fzf_tags_command = 'ctags -R --exclude={env,.env,venv,.venv}'

map <leader>ri :ImportName<CR>
map <leader>rI :ImportNameHere<CR>

function! CopyModulePath()
  let l:module_path = luaeval('require("python-utils").get_module_path()')
  let @+ = module_path

  echo('Copied to clipboard: ' . module_path)
endfunction

noremap <silent> <leader>rc :call CopyModulePath()<CR>

" ======================================================================
" Python specific settings END
" ======================================================================

" ======================================================================
" GIT Mapping START
" ======================================================================

nmap <leader>gu :GitGutterUndoHunk<CR>
nmap <leader>gp :GitGutterPreviewHunk<CR>
nmap <leader>gP :Git push -u origin HEAD<CR>
nmap <leader>gb :Git blame<CR>

" ======================================================================
" GIT Mapping END
" ======================================================================

" AgIn: Start ag in the specified directory
"
" e.g.
"   :AgIn .. foo
function! s:ag_in(bang, ...)
  if !isdirectory(a:1)
    throw 'not a valid directory: ' .. a:1
  endif
  " Press `?' to enable preview window.
  call fzf#vim#ag(join(a:000[1:], ' '), fzf#vim#with_preview({'dir': a:1}, 'up:50%:hidden', '?'), a:bang)
endfunction

function! s:ag_no_tests(bang, ...)
  call fzf#vim#ag(join(a:000[1:], ' '), '--ignore ".*test.*"', fzf#vim#with_preview({}, 'up:50%:hidden', '?'), a:bang)
endfunction

command! -bang -nargs=+ -complete=dir AgIn call s:ag_in(<bang>0, <f-args>)
command! -bang -nargs=? -complete=dir AgNoTests call s:ag_no_tests(<bang>0, <f-args>)

" Add tag generation status to the statusline
set statusline+=%{gutentags#statusline()}

" Load setting tightly related to plugin functionality
source ~/.config/nvim/plugin-configs/vimspector.vim
source ~/.config/nvim/plugin-configs/vimwiki.vim

source ~/.config/nvim/lsp.vim
