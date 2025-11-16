set nocompatible

if has("vms")
  set nobackup
else
  set backup
endif

set history=10000
set ruler " show the cursor position all the time
set showcmd " display incomplete commands

" do not enable mouse by default
set mouse=
set ttymouse=xterm2

syntax on
set incsearch " do incremental searching
set hlsearch " highlight search results
nnoremap <leader><space> :nohlsearch<CR>

" /foo matches all foo Foo FOO
set ignorecase
set nosmartcase

filetype plugin indent on

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" additional filetypes
autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif
autocmd BufRead,BufNewFile *.go set filetype=go
autocmd BufRead,BufNewFile *.conf set filetype=dosini
autocmd BufRead,BufNewFile *.inc set filetype=sh
autocmd BufRead,BufNewFile *.yql set filetype=sql

" configs for filetypes
autocmd FileType html,css,scss setlocal ts=4 sts=4 sw=4
autocmd FileType rst setlocal tw=79 spell
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
" autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd FileType gitcommit setlocal spell

" save session
nnoremap <leader>s :mksession<CR>

" Remove Trailing Whitespaces
command! RTW :%s/\s\+$//e

" automatically RTW
autocmd BufWritePre *.py,*.cpp,*.h :RTW

" also highlight them and tabs
match Todo /\s\+$/
set list
set listchars=tab:>-

highlight ColorColumn ctermbg=magenta
highlight ColorColumnLong ctermbg=brown

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

if !isdirectory(expand("~/.vim/backup"))
    call mkdir(expand("~/.vim/backup"), "p")
endif
set backupdir=~/.vim/backup

set splitright
set textwidth=0
" make command completion spawn a menu
set wildmenu
" better line navigation
set backspace=indent,eol,start
set whichwrap=b,[,],<,>

" set W to be 'sudo w'
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" Wq is ok
command! Wq wq

" ';' is the new ':', I don't really use it though
nnoremap  ;  :

" redo in just 2 btns
noremap rr <C-r>

let CursorColumnI = 0 " the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

filetype off  " required!
set runtimepath+=~/.vim/bundle/Vundle.vim/
set runtimepath+=~/.vim/bundle/ultisnips/
set runtimepath+=~/.vim/bundle/vim-snippets/
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" important and everyday use
Plugin 'Valloric/YouCompleteMe'
Plugin 'Valloric/ListToggle'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/powerline'
Plugin 'SirVer/ultisnips'
Plugin 'dense-analysis/ale'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'mileszs/ack.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'Vimjas/vim-python-pep8-indent'

Plugin 'alvan/vim-closetag'
Plugin 'juneedahamed/svnj.vim'

Plugin 'stevearc/vim-arduino'

" secondary
Plugin 'Yggdroot/indentLine'
Plugin 'nvie/vim-togglemouse'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'honza/vim-snippets'
Plugin 'kien/ctrlp.vim'
Plugin 'vitorgalvao/autoswap_mac'

" should look into
Plugin 'ustcyue/proto-number'
Plugin 'terryma/vim-expand-region'
Plugin 'idanarye/vim-merginal'
Plugin 'Shougo/unite.vim'
Plugin 'Rykka/InstantRst'
Plugin 'easymotion/vim-easymotion'

" color and syntax
Plugin 'IN3D/vim-raml'
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'wting/rust.vim'
Plugin 'vim-scripts/CycleColor'
Plugin 'lepture/vim-jinja'
Plugin 'saltstack/salt-vim'
Plugin 'sudar/vim-arduino-syntax'
" js
Plugin 'yuezk/vim-js'
Plugin 'MaxMEllon/vim-jsx-pretty'
Plugin 'prettier/vim-prettier'


call vundle#end()
filetype plugin indent on     " required!

" nerdtree
nmap <C-n> :NERDTreeToggle<CR>
" open tag definition in a vsplit

nmap <silent> <leader>f :ALEFix<CR>
nmap <silent> <leader>n :ALENext<CR>
nmap <silent> <leader>p :ALEPrevious<CR>

" automatically close loclist if I :wq a window with lint errors
autocmd WinEnter * if &buftype ==# 'quickfix' && winnr('$') == 1 | quit | endif

let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0

let g:ale_fixers = {'python': ['black']}
let g:ale_fix_on_save = 0
let g:ale_python_black_options = '-S -l 120'

let g:ale_linters = {
\    'python': ['flake8', 'pylint', 'pyright'],
\    'cpp': [],
\    'c': [],
\}


let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.json,*.css,*.scss,*.less,*.graphql Prettier

let g:ycm_register_as_syntastic_checker = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_always_populate_location_list = 1


" trigger semantic completion for imports
let g:ycm_semantic_triggers =  {
  \ 'python': ['.', 'import ', 're!import [,\w ]+, '],
  \ 'css': [ 're!^', 're!^\s+', ': ' ],
  \ 'scss': [ 're!^', 're!^\s+', ': ' ],
  \ 'cpp': ['.', '->', '::'],
  \ 'c': ['->', '.'],
  \ }
let g:ycm_show_diagnostics_ui = 1


" jedi-vim
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
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
let g:jedi#force_py_version = 3

nmap <silent> <leader>gs :GoDef<CR>
nmap <silent> <leader>ga :vsplit<CR> :GoDef<CR>

nmap <silent> <leader>= :vertical resize +5<CR>
nmap <silent> <leader>- :vertical resize -5<CR>



let g:airline_theme = 'molokaitef'
let g:airline_powerline_fonts = 1

let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-p>"
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

let g:ycm_server_keep_logfiles=1

" CtrlP settings
let g:ctrlp_open_new_file = 'v'

autocmd VimEnter UltiSnipsAddFiletypes django

" use ag if available
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

let g:ackhighlight = 1
let g:ackpreview = 1
let g:ackautoclose = 1
let g:ack_autofold_results = 0
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
nnoremap <Leader>f :vertical wincmd f<CR>


let g:vim_jsx_pretty_highlight_close_tag = 0

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

let g:go_def_reuse_buffer = 1
let g:indentLine_enabled = 0

function! FollowTag()
  if !exists("w:tagbrowse")
    vsplit
    let w:tagbrowse=1
  endif
  execute "tag " . expand("<cword>")
endfunction

nnoremap <c-\> :call FollowTag()<CR>
" <c-\> open in vsplit
" <c-]> open in current window

function! ArduinoStatusLine()
  let port = arduino#GetPort()
  let line = '[' . g:arduino_board . '] [' . g:arduino_programmer . ']'
  if !empty(port)
    let line = line . ' (' . port . ':' . g:arduino_serial_baud . ')'
  endif
  return line
endfunction

autocmd BufNewFile,BufRead *.ino let g:airline_section_x='%{ArduinoStatusLine()}'

set termguicolors
" Softer popup menu colors
highlight Pmenu      ctermfg=250 ctermbg=237 guifg=#d0d0d0 guibg=#3a3a3a
highlight PmenuSel   ctermfg=0   ctermbg=110 guifg=#000000 guibg=#87afaf
highlight PmenuSbar  ctermbg=236 guibg=#2e2e2e
highlight PmenuThumb ctermbg=245 guibg=#8a8a8a

