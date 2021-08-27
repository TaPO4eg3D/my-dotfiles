set ts=4
set sw=4

function TypeScriptRenameFile()
  " TODO: Finish that function
  let l:buff_name = expand('%:p') 
  let l:new_file_path = input("Input new filename: ", l:buff_name)

  if !empty(glob(l:new_file_path))
    echo "\r"
    echo "File with that name already exists!"
    return
  endif
endfunction

nnoremap <leader>bR :call TypeScriptRenameFile()<CR>
