set nocompatible              " be iMproved, required

" Enable auto-completion
filetype off

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
" Verty powerfull plugin for working with Git
call minpac#add('tpope/vim-fugitive')
" Support for the 'dot' command for plugins such as vim-surround and so on
call minpac#add('tpope/vim-repeat')
" Fuzzy Search
call minpac#add('junegunn/fzf', {'do': { -> fzf#insall()} })
call minpac#add('junegunn/fzf.vim')
" Support for SCSS syntax
call minpac#add('cakebaker/scss-syntax.vim')
" Nice looking VIM Theme
call minpac#add('morhetz/gruvbox')
call minpac#add('tpope/vim-commentary')
call minpac#add('jlanzarotta/bufexplorer')
call minpac#add('raimondi/delimitmate')
" Support for LaTeX
call minpac#add('lervag/vimtex')
" Auto keyboard layout switcher
call minpac#add('lyokha/vim-xkbswitch')
" Add markdown support
call minpac#add('godlygeek/tabular')
call minpac#add('plasticboy/vim-markdown')

" VIM Intellisense
call minpac#add('neoclide/coc.nvim', {'branch': 'release'})

" ======================================================================
" Plugins END
" ======================================================================


" ======================================================================
" Common keymaps START
" ======================================================================
" Put your non-Plugin stuff after this line
let mapleader = "\<Space>"

"Open FileExplorer
nmap <leader>nn :CocCommand explorer<CR>

" Convert tabs to spaces when press F9
map <F9> :%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<CR>

" Open fzf
nnoremap <c-p> :GFiles<cr>

" ======================================================================
" Common keymaps END
" ======================================================================


" ======================================================================
" Common settings START
" ======================================================================
" Display number of lines
set rnu

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

" Setup of auto keyboard layout switch
let g:XkbSwitchEnabled = 1
let g:XkbSwitchLib = '/usr/local/lib/libg3kbswitch.so' " Only works with GNOME

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
colorscheme gruvbox

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
nmap <leader>c :VimtexCompile<CR>

" Navigate by visual lines in TeX files
au FileType tex noremap <buffer> j gj
au FileType tex noremap <buffer> k gk

" ======================================================================
" Latex setup END
" ======================================================================

" ======================================================================
" Intellisense setup START
" ======================================================================
  let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-spell-checker',
    \ 'coc-actions',
    \ 'coc-emmet',
    \ 'coc-tsserver',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-cssmodules',
    \ 'coc-yaml',
    \ 'coc-python',
    \ 'coc-explorer',
    \ 'coc-svg',
    \ 'coc-vimlsp',
    \ 'coc-xml',
    \ 'coc-yank',
    \ 'coc-json',
    \ 'coc-vimtex',
    \ ]

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Choose variants through Tab and Shift + Tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Press Enter to choose variant for completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Select the first completion item and confirm the completion when no item
" has been selected
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gR <Plug>(coc-rename)

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" ======================================================================
" Intellisense setup END
" ======================================================================
