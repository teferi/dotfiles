" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup " keep a backup file
endif

set history=100
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so
" that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set ignorecase
  set smartcase
endif

filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
au BufRead,BufNewFile *.go set filetype=go

" nginx settings
au BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif

autocmd FileType ruby set ts=2 sts=2 sw=2
autocmd FileType html set ts=2 sts=2 sw=2

" automatically remove trailing whitespaces
autocmd BufWritePre *.py :%s/\s\+$//e
command RTW :%s/\s\+$//e

" also highlight them and some other stuff
match Todo /\s\+$/
exec "set listchars=tab:\uBB\uBB"
set list

" comment line, selection with Ctrl-N,Ctrl-N
"au BufEnter *.py nnoremap  <C-N><C-N>    mn:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR>:noh<CR>`n
"au BufEnter *.py inoremap  <C-N><C-N>    <C-O>mn<C-O>:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR><C-O>:noh<CR><C-O>`n
"au BufEnter *.py vnoremap  <C-N><C-N>    mn:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR>:noh<CR>gv`n

" uncomment line, selection with Ctrl-N,N
"au BufEnter *.py nnoremap  <C-N>n     mn:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR>:s/^#$//ge<CR>:noh<CR>`n
"au BufEnter *.py inoremap  <C-N>n     <C-O>mn<C-O>:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR><C-O>:s/^#$//ge<CR><C-O>:noh<CR><C-O>`n
"au BufEnter *.py vnoremap  <C-N>n     mn:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR>gv:s/#\n/\r/ge<CR>:noh<CR>gv`n

set autoindent
set expandtab
set smarttab
set tabstop=4 shiftwidth=4 softtabstop=4
set whichwrap=b,[,],<,>
set virtualedit=onemore
set nowrap
set backupdir=~/.vimbackup
set splitright
set textwidth=0
" make command completion spawn a menu
set wildmenu

"set colorcolumn=121
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%121v', 100)

set pastetoggle=<F2>
"set nofoldenable
"set foldmethod=indent
"set foldlevel=1
"set foldnestmax=10
"nnoremap <space> za
"vnoremap <space> zf

" set W to be 'sudo w'
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" ';' is the new ':'
nnoremap  ;  :
" not the other way round
"nnoremap  :  ;

if has('python')

function! ActVEnv()
python << EOPYTHON
try:
    import os
    import os.path
    import sys

    virtualenv = os.environ.get('VIRTUAL_ENV')
    if virtualenv and os.path.isdir(virtualenv):
        activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py')
        if os.path.exists(activate_this):
            execfile(activate_this, dict(__file__=activate_this))
            sys.path.append(os.path.join(virtualenv, '../'))
            os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
            #print "activated '{0}' virtualenv".format(virtualenv)
except:
    pass
EOPYTHON
endfunction

function! PythonPath()
python << EOPYTHON
import os.path
import sys
curdir = os.path.abspath(os.path.curdir)
while curdir != '/':
    dr = os.path.join(curdir, 'apps')
    if os.path.exists(dr) and dr not in sys.path:
        sys.path.insert(0, dr)
    curdir = os.path.abspath(curdir + '/..')
EOPYTHON
endfunction

call PythonPath()
call ActVEnv()
endif

if filereadable($VIRTUAL_ENV . '/.vimrc')
    source $VIRTUAL_ENV/.vimrc
endif


filetype off  " required!

set runtimepath+=~/.vim/bundle/vundle/
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'


" call vundle#rc()
NeoBundle 'gmarik/vundle'

NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'Syntastic'
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'rizzatti/dash.vim'
NeoBundle 'rizzatti/funcoo.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'vim-scripts/django.vim'
NeoBundle 'vitorgalvao/autoswap_mac'
NeoBundle 'dhruvasagar/vim-table-mode'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundle 'tell-k/vim-autopep8'

call neobundle#end()

NeoBundleCheck

" rewrite module to make it work
set title titlestring=

filetype plugin indent on     " required!

call pathogen#infect()

" nerdtree
nmap <C-n> :NERDTreeToggle<CR>
" open tag definition in a vsplit
nmap <C-p> :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>

set tags=.tags
if filereadable('.cscope.db')
    cs add .cscope.db
endif


"nmap <C-t> :tabnew<CR>
nmap <C-d> :Dash!<CR>
"nmap <silent> <C-d> <Plug>DashSearch
"nmap <silent> <leader>d <Plug>DashSearch
"nmap <C-b> :CommandT<CR>
"nmap <C-m> :tabnew<CR>:CommandT<CR>
command JJ :set filetype=htmljinja

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
                           \  'active_filetypes': ['python', 'c', 'js'],
                           \ 'passive_filetypes': ['html'] }
let g:syntastic_c_checkers = ['gcc', 'splint', 'ycm']
let g:syntastic_cpp_compiler_options = '-std=c++0x'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_auto_refresh_includes = 1

let g:ycm_register_as_syntastic_checker = 0
let g:ycm_confirm_extra_conf = 0

let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1

let g:jedi#auto_initialization = 0
let g:jedi#popup_select_first = 0
let g:jedi#use_splits_not_buffers = "right"

let g:table_mode_corner_corner = '+'

let g:autopep8_max_line_length = 120
