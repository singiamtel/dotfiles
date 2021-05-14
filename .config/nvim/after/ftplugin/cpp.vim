compiler gcc
if(!filereadable("./Makefile"))
	set makeprg=g++\ -g\ -o\ %<\ %
endif

set commentstring=//%s
