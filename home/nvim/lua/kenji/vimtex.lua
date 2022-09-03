vim.cmd([[
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_types = {
\ 'sections' : {'parse_levels': 1},
\}
set conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_indent_enabled=0
highlight Conceal guifg=#F8F8F0 guibg=#5A5475
au FileType tex nmap <leader>d <Plug>(vimtex-doc-package)
au FileType tex nmap <leader>t ;VimtexTocToggle
let g:vimtex_compiler_latexmk = {
"\ 'backend' : DEPENDS ON SYSTEM (SEE BELOW),
\ 'background' : 1,
"\ 'build_dir' : ' ',
\ 'callback' : 1,
\ 'continuous' : 1,
\ 'executable' : 'latexmk',
\ 'hooks' : [],
\ 'options' : [
\   '-verbose',
\   '-file-line-error',
\    '--shell-escape',
\   '-synctex=1',
\   '-interaction=nonstopmode',
\ ],
\}

" Close the error window after writing a bit
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
    " Configure table of contents
" - Hide the help
" - Disable the label list by default
" - Resize too automatically
" - Increase size from 30 to 50
" - Reduce from 3 levels (4 parts) to 2 (3 parts)
let g:vimtex_toc_config = {
			\ 'show_help': 0,
			\ 'layer_status': {'content': 1, 'todo': 1, 'label': 1, 'fixme': 1},
			\ 'split_width': 50,
			\ 'tocdepth': 2
			\}
			" - Do not show preamble in the list
let g:vimtex_toc_show_preamble = 0

let s:lbl_todo  = '✅D: '
let s:lbl_warn  = '⚡W: '
let s:lbl_fixme = '⛔F: '

let g:vimtex_toc_todo_labels = {
			\ 'TODO': s:lbl_todo,
			\ 'FIXME': s:lbl_fixme, }
]])
