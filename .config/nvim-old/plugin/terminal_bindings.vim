if has('nvim')
	au TermOpen * setlocal nonumber norelativenumber
	tnoremap <Esc> <C-\><C-n>
	au TermOpen  * setlocal nonumber | startinsert
	au TermClose * setlocal   number | call feedkeys("\<C-\>\<C-n>")
endif
