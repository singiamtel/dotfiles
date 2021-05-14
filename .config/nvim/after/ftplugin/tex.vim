compiler tex
setlocal spell spelllang=es

" For vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=1
let g:tex_conceal='abdmgs'

autocmd VimLeave * !texclear %
