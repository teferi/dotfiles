set nocompatible

if has("vms")
  set nobackup
else
  set backup
endif

set history=10000
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching

" do not enable mouse by default
set mouse=
set ttymouse=xterm2

syntax on
set hlsearch

" /foo matches all foo Foo FOO
set ignorecase
set nosmartcase

filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" additional filetypes
autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif
autocmd BufRead,BufNewFile *.go set filetype=go

" configs for filetypes
autocmd FileType ruby set ts=2 sts=2 sw=2
autocmd FileType html set ts=2 sts=2 sw=2
autocmd FileType rst set tw=79

" Remove Trailing Whitespaces
command! RTW :%s/\s\+$//e

" automatically RTW for py/rst. would result in -1 anyway
autocmd BufWritePre *.py :RTW
autocmd BufWritePre *.rst :RTW

" also highlight them and tabs
match Todo /\s\+$/
autocmd BufEnter *.py set list
autocmd BufEnter *.py exec "set listchars=tab:\uBB\uBB"
highlight ColorColumn ctermbg=magenta

" highlight 79th character where sensible.
autocmd BufEnter *.py call matchadd('ColorColumn', '\%79v', 100)
autocmd BufEnter *.rst call matchadd('ColorColumn', '\%79v', 100)

" read/write files automatically
set autoread
set autowrite

" your typical pythonc tabs
set autoindent
set copyindent
set expandtab
set smarttab
set tabstop=4 shiftwidth=4 softtabstop=4
set nowrap

set undodir=~/.vim/undodir
set undofile
set undolevels=10000
set undoreload=10000

set dictionary+=/usr/share/dict/words
set laststatus=2
set title
set virtualedit=onemore
set backupdir=~/.vim/backup
set splitright
set textwidth=0
" make command completion spawn a menu
set wildmenu
" better line navigation
set backspace=indent,eol,start
set whichwrap=b,[,],<,>

set pastetoggle=<F2>
" folding requires some more work
"set nofoldenable
"set foldmethod=indent
"set foldlevel=1
"set foldnestmax=10
"nnoremap <space> za
"vnoremap <space> zf

" set W to be 'sudo w'
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Wq is ok
command! Wq wq

" ';' is the new ':', I don't really use it though
nnoremap  ;  :

" redo in just 2 btns
noremap rr <C-r>

" I really don't like my cursor being moved
" noremap a i

" And stay there
" inoremap <silent> <Esc> <C-O>:stopinsert<CR>
" inoremap <silent> <Esc> <Esc>`^
" inoremap ff <Esc>l

" set timeoutlen=500

let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif




if has('python')

function! ActVEnv()
python << EOPYTHON
try:
    import os
    import os.path
    import sys

    def act_venv(venv):
        activate_this = os.path.join(venv, 'bin', 'activate_this.py')
        if os.path.exists(activate_this):
            execfile(activate_this, dict(__file__=activate_this))
            sys.path.append(os.path.join(venv, '../'))

    virtualenv = os.environ.get('VIRTUAL_ENV')
    if virtualenv and os.path.isdir(virtualenv):
        act_venv(virtualenv)
    else:
        for tox in ['pep8', 'venv', 'py27']:
            if os.path.isdir(os.path.join('.tox/', tox)):
                act_venv(os.path.join('.tox/', tox))
                break
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
set runtimepath+=~/.vim/bundle/ultisnips/
set runtimepath+=~/.vim/bundle/vim-snippets/
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'


" important and everyday use
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'nvie/vim-togglemouse'
NeoBundle 'Lokaltog/powerline'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'bling/vim-airline'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'davidhalter/jedi-vim'

" secondary
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'dhruvasagar/vim-table-mode'
NeoBundle 'gmarik/vundle'
NeoBundle 'honza/vim-snippets'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'vitorgalvao/autoswap_mac'

" should look into
NeoBundle 'terryma/vim-expand-region'
NeoBundle 'idanarye/vim-merginal'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Rykka/InstantRst'

" color and syntax
NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundle 'wting/rust.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'endel/vim-github-colorscheme'
NeoBundle 'vim-scripts/CycleColor'

call neobundle#end()

NeoBundleCheck

filetype plugin indent on     " required!

" nerdtree
nmap <C-n> :NERDTreeToggle<CR>
" open tag definition in a vsplit
nmap <C-p> :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>

" region expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

set tags=.tags
if filereadable('.cscope.db')
    cs add .cscope.db
endif

nmap <silent> <leader>ev :vsplit $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" I stopped using tabs really
" nmap <C-t> :tabnew<CR>

command! JJ :set filetype=htmljinja

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_mode_map = { 'mode': 'active',
                           \  'active_filetypes': ['python', 'c', 'js'],
                           \ 'passive_filetypes': ['html'] }
" need to edit pylint config before it is usable
" let g:syntastic_python_checkers = ['pep8', 'flake8', 'pylint']
let g:syntastic_python_checkers = ['pep8', 'flake8']

let g:syntastic_c_checkers = ['gcc', 'make', 'ycm']
let g:syntastic_c_compiler_options = '-Wall'

let g:syntastic_cpp_compiler_options = '-std=gnu++14'
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_auto_refresh_includes = 1

let g:syntastic_javascript_checkers = ['jscs', 'jshint', 'eslint']
" expands when defined, not when used.
" let g:syntastic_sh_shellcheck_args = ['--exclude=SC2139']
let g:syntastic_aggregate_errors = 1

let g:ycm_register_as_syntastic_checker = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1

" trigger semantic completion for imports
let g:ycm_semantic_triggers =  {
  \ 'python' : ['.', 'import ', 're!import [,\w ]+, '],
  \ }

" jedi-vim
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#completions_enabled = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = 0

let g:jedi#goto_assignments_command = "<leader>da"
let g:jedi#goto_definitions_command = "<leader>dd"
let g:jedi#documentation_command = "<leader>dk"
let g:jedi#usages_command = "<leader>du"
let g:jedi#rename_command = "<leader>dr"
let g:jedi#use_splits_not_buffers = "right"
let g:jedi#use_tabs_not_buffers = 0

" I need to remember how to use it =(
let g:table_mode_corner_corner = '+'

let g:airline_theme = 'molokaitef'
let g:airline_powerline_fonts = 1

let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-p>"
let g:UltiSnipsUsePythonVersion = 2
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

let g:ycm_server_keep_logfiles=1

autocmd VimEnter UltiSnipsAddFiletypes django

" use ag if available
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

let g:ackhighlight = 1
let g:ackpreview = 1
let g:ackautoclose = 1
" let g:ack_autofold_results = 1

" github color scheme is nice
set t_Co=256

" csope
nmap <leader>cs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ct :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ce :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cf :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>ci :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>cd :vert scs find d <C-R>=expand("<cword>")<CR><CR>

nmap <C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

if &diff
    colorscheme github-tef
endif
au FilterWritePre * if &diff | colorscheme github-tef | endif
