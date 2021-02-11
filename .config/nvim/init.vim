set nocompatible              " be iMproved, required
filetype plugin on

" Russian keyboard fix
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

packadd minpac
call minpac#init()

" ======================================================================
" Plugins START
" ======================================================================
" Emmet we all know and love
call minpac#add('mattn/emmet-vim')
" That fancy line that show lots of info about our current state
call minpac#add('bling/vim-airline')
" Shows syntax error, I believe it is used by other linter and plugins too
call minpac#add('scrooloose/syntastic')
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
" NeoVIM Completion
call minpac#add('nvim-lua/completion-nvim')

" Highlight colors right in the vim
call minpac#add('lilydjwg/colorizer')
" Support for PUG files
call minpac#add('digitaltoad/vim-pug')
" Display file structure using CTags
call minpac#add('majutsushi/tagbar')
" Support for TypeScript
call minpac#add('leafgarland/typescript-vim')
" Shows Git info
call minpac#add('airblade/vim-gitgutter')
" Debugger for VIM
call minpac#add('puremourning/vimspector')
" NERDTree
call minpac#add('preservim/nerdtree')
" VIM DevIcons
call minpac#add('ryanoasis/vim-devicons')
" Git support for NERDTree
call minpac#add('Xuyuanp/nerdtree-git-plugin')
" Automatic tag management
call minpac#add('ludovicchabant/vim-gutentags')
" Automatic python imports using Tags
call minpac#add('mgedmin/python-imports.vim')
" Better deafults for nvim-lsp
call minpac#add('RishabhRD/popfix')
call minpac#add('RishabhRD/nvim-lsputils')
" VimWiki
call minpac#add('vimwiki/vimwiki')
" Zettelkasten
call minpac#add('michal-h21/vim-zettel')
" Writing tables in markup languages like Markdown becomes really easy
call minpac#add('dhruvasagar/vim-table-mode')
" ======================================================================
" Plugins END
" ======================================================================


" ======================================================================
" Common keymaps START
" ======================================================================
" Put your non-Plugin stuff after this line
let mapleader = "\<Space>"

"Toggle FileExplorer
nmap <leader>nn :NERDTreeToggle<CR>
" Find file in NERDTree
nmap <leader>nf :NERDTreeFind<CR>

"Toggle TagBar
nmap <leader>nt :TagbarToggle<CR>

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
set clipboard=unnamedplus               " Copy paste between vim and everything else

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
packadd! dracula
syntax enable
colorscheme dracula
hi Normal guibg=NONE ctermbg=NONE

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
  endif
endif

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

" ======================================================================
" Python specific settings END
" ======================================================================

" Add tag generation status to the statusline
set statusline+=%{gutentags#statusline()}

" Load setting tightly related to plugin functionality
source ~/.config/nvim/plugin-configs/vimspector.vim
source ~/.config/nvim/plugin-configs/vimwiki.vim

source ~/.config/nvim/lsp.vim
