" Setting for Vimspector

" ===========================
" MAPPING START
" ===========================

nmap <leader>dd <Plug>VimspectorContinue
nmap <leader>ds <Plug>VimspectorStop
nmap <leader>dr <Plug>VimspectorRestart
nmap <leader>dp <Plug>VimspectorPause
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>dB <Plug>VimspectorAddFunctionBreakpoint
nmap <leader>do <Plug>VimspectorStepOver
nmap <leader>di <Plug>VimspectorStepInto
nmap <leader>df <Plug>VimspectorStepOut

" ===========================
" MAPPING END
" ===========================
packadd! vimspector
