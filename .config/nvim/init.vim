call plug#begin('~/.config/nvim/plugged')
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'

Plug 'haya14busa/incsearch.vim'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'digitaltoad/vim-pug'

Plug 'machakann/vim-highlightedyank'
" Plug 'ludovicchabant/vim-gutentags'

Plug 'vimwiki/vimwiki'
Plug 'tpope/vim-markdown'

" WTF
" Plug 'codota/tabnine-vim'


" COC
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} " this is for auto complete, prettier and tslinting

let g:coc_global_extensions = ['coc-tsserver', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-clangd']  " list of CoC extensions needed
" 'coc-tslint-plugin', 

Plug 'jiangmiao/auto-pairs' "this will auto close ( [ {

" these two plugins will add highlighting and indenting to JSX and TSX files.
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

"END COC

Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf.vim'

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'

Plug 'kdheepak/lazygit.nvim', { 'branch': 'nvim-v0.4.3' }

Plug 'airblade/vim-rooter'
Plug 'liuchengxu/vim-which-key'

Plug 'jiangmiao/auto-pairs'

Plug 'metakirby5/codi.vim'

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

Plug 'liuchengxu/graphviz.vim'
Plug 'chrisbra/csv.vim', 				{'for' : 'csv'}
Plug 'lervag/vimtex', 					{'for' : 'tex'}
Plug 'KeitaNakamura/tex-conceal.vim', 	{'for' : 'tex'}

Plug 'arcticicestudio/nord-vim'
call plug#end()

colorscheme nord
nnoremap <SPACE> <Nop>
let mapleader=" "

filetype plugin indent on
syntax on
set backspace=indent,eol,start
set clipboard=unnamedplus
set confirm
set ignorecase
set hidden
set mouse=a
set nohlsearch
set nrformats=alpha,hex,bin
set noshowmode
set nospell
set noswapfile
set number
" Set path recursive to current folder, might cause lag on big codebases
set path=.,**
set shortmess=oOtTatI " Multiple flags, :help shortmess // +=?
set spelllang=en_us,es
set tabstop=4 shiftwidth=4
set termguicolors
set timeoutlen=300
set undodir=$HOME/.config/nvim/undo
set undofile
set nolist lcs=tab:\┊\ "

inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

inoremap <F1> <nop>
" nnoremap <CR> :
" vnoremap <CR> :
nnoremap N Nzzzv
nnoremap Q <nop>
nnoremap n nzzzv
noremap <F1> <nop>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <F1> :QFix<cr>
nmap <F2> <Plug>(coc-rename)

nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
nnoremap <leader>s :UltiSnipsEdit<cr>
nnoremap <leader>d :SearchDoc<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>s :Rg<cr>
nnoremap <leader>g :LazyGit<cr>
nnoremap <leader>a :e #<cr>

let $RTP=split(&runtimepath, ',')[0]

" let airline_theme="atomic"
let g:rooter_silent_chdir = 1
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:netrw_dirhistmax = 0
set conceallevel=2
hi Conceal ctermbg=none
" hi clear SpellBad
hi SpellBad cterm=underline ctermfg=red

let g:tex_flavor='latex'
let AutoPairs= {'(':')', '[':']', '{':'}'}

let g:vimwiki_list = [{'path': '~/main/vimwiki', 'path_html': '~/main/vimwiki/public_html/'}]
