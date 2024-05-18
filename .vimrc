" Plugins
call plug#begin('~/.vim/plugged')
Plug 'cocopon/iceberg.vim'
Plug 'gkeep/iceberg-dark'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-obsession'
Plug 'vim-latex/vim-latex'
Plug 'wincent/terminus'
call plug#end()

" Remove delay with ESC
set timeoutlen=1000
set ttimeoutlen=5

" Stolen from vim sensible
filetype plugin indent on
syntax enable
set synmaxcol=500
set scrolloff=3
set sidescrolloff=7
set history=500
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

" bruh
set colorcolumn=80
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set number
set ruler
set pastetoggle=<F2>

" lol
cmap w!! w !sudo tee > /dev/null %
nnoremap q: <nop>
nnoremap Q <nop>

" spaces > tabs
set tabstop=4 " show existing tab with 4 spaces width
set shiftwidth=4 " when indenting with visual >, use 4 spaces width
set expandtab " on pressing tab, insert 4
set softtabstop=4 " delete and add 4 spaces when using tab/backspace
set autoindent 
" auto tab fixer
command FixTabs retab | normal gg=G

" vim latex
let g:Tex_MultipleCompileFormats = 'pdf'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:tex_no_error=1
let g:Imap_UsePlaceHolders = 0
let g:Tex_FoldedEnvironments = "verbatim,comment,eq,gather,align,figure,table,thebibliography,keywords,abstract,titlepage,problem"
let g:Tex_UseMakefile=0

" Color & customization
set background=dark
silent! colo iceberg 
let g:lightline = {'colorscheme': 'icebergDark',}
map <C-o> :NERDTreeToggle<CR> <bar> :normal r<CR>

" Speed find
set incsearch
set ignorecase
set smartcase

" Command line
set cmdheight=1
set wildmenu
set laststatus=2

" nope
set noerrorbells
set nobackup
set nowb
set noswapfile
