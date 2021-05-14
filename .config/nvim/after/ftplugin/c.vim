if (&ft != 'c')
	" Without this, cpp ftplugin sources c ftplugin
	finish
endif

compiler gcc
if(!filereadable("./Makefile"))
	set makeprg=gcc\ -g\ -o\ \"%<\"\ \"%\"
endif

set commentstring=//%s
