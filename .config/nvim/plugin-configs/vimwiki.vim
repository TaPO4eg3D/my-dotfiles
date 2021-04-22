" Support for VimTableMode plugin
let g:vimwiki_table_mappings=0
let g:vimwiki_table_auto_fmt=0

au! BufRead,BufNewFile *.wiki nmap <leader>p :call VimwikiPasteClipboardImage()<CR>
au! BufRead,BufNewFile *.wiki call LoadVimWikiSurrounding()


function LoadVimWikiSurrounding() abort
  " Support for VimTableMode plugin
  let g:table_mode_corner = '|'

  let g:surround_{char2nr('b')} = "*\r*"
  let g:surround_{char2nr('i')} = "_\r_"
  let g:surround_{char2nr('l')} = "_*\r*_"
  let g:surround_{char2nr('s')} = "~~\r~~"
  let g:surround_{char2nr('c')} = "`\r`"
endfunction


function VimwikiPasteClipboardImage() abort
  " Check if there is an image in the clipboard
  silent let l:can_copy = system('xclip -selection clipboard -t TARGETS -o') =~ 'image/png'

  if !l:can_copy
    echo 'You are trying to insert an image but there is no such in the cliboard!'
    return
  endif

  " Create a media directory if it does not exist
  let l:img_directory = getcwd() . '/media'

  if !isdirectory(l:img_directory)
    silent call mkdir(l:img_directory)
  endif

  " Define pasted image path based on the current localtime
  let l:img_name = 'pasted-image-' . localtime() . '.png'
  let l:img_path = l:img_directory . '/' . l:img_name

  let l:xclip_command = 'xclip -selection clipboard -t image/png -o > ' . l:img_path

  silent call system(l:xclip_command)
  if v:shell_error == 1
    echo 'Error while inserting an image'
  else
    execute 'normal! i{{file:' . './media/' . l:img_name . '}}'
  endif

endfunction
