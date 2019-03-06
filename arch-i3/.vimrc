"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" __   _____ __  __ ___  ___ 
" \ \ / /_ _|  \/  | _ \/ __|
"  \ V / | || |\/| |   / (__ 
"   \_/ |___|_|  |_|_|_\\___|
"
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Notes :
" If you're editing this file, you can enter :so % to source it

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" General Controls
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
let s:enable_plugins = 1
let s:auto_close_brackets = 0

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Plugins
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
if s:enable_plugins != 0
    " Pathogen
    execute pathogen#infect()
    " Syntastic
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:pymode_lint = 1
    let g:pyemode_lint_on_write = 0
    let g:syntastic_loc_list_height=5
    " Nerdtree - start automatically
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    let g:NERDTreeWinSize=30 " width
    let g:Tlist_WinWidth=30 " width
    " CtrlP - fuzzy file search
    set runtimepath^=~/.vim/bundle/ctrlp.vim
    " CtrlP plugin
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_root_markers = ['pom.xml', '.p4ignore']
    let g:ctrlp_switch_buffer = 'et'
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip
    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
    let g:ctrlp_user_command = 'find %s -type f' 
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    " CtrlP shortcuts
    noremap <silent> <C-S>          :update<CR>
    vnoremap <silent> <C-S>         <C-C>:update<CR>
    inoremap <silent> <C-S>         <C-O>:update<CR>:inoremap <c-s> <Esc>:Update<CR>
    "jedi
    "init jedi plugin
    let g:jedi#auto_initialization = 0
    let g:jedi#auto_vim_configuration = 0
    ""tabs when going to a definition
    let g:jedi#use_tabs_not_buffers = 1
    "jedi for splits
    let g:jedi#use_splits_not_buffers = "left"
    " tagbar (class browser) activation - needs ctags installed
    nmap <F10> :TagbarToggle<CR>
    """""" airline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#formatter = 'default'
    set laststatus=2 " at the bottom
endif
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Basic behaviour
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Highlight syntax
syntax on
" Don't create backup files to avoid potential annoying Q's on opening
set noswapfile
" Don't let OS overwrite VIM settings, re-source .vimrc safely
set nocompatible 
" Attempt auto-indent based on filetype
filetype indent plugin on
" Easy switching and editing multiple files
set hidden
" Show partial commands in the last line of the screen
set showcmd
" Uncomment the following to have Vim jump to the last position
" when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
	\| exe "normal! g'\"" | endif
endif
" Automatically switch to the directory of the opened file
autocmd BufEnter * silent! lcd %:p:h


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Text insertion & test misc
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Use <F9> to toggle between 'paste' and 'nopaste' mode
set pastetoggle=<F9>
" Better command-line completion
set wildmenu
" Char encoding, mainly so NERDtree can show arrow symbols
set encoding=utf-8


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Window options & scrolling
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Default size
set lines=45 columns=100
" Show line numbers on the left
set number relativenumber " hybrid line no; show line num, others relative
    " More on that:
    " set nonumber norelativenumber  " turn hybrid line numbers off
    " set !number !relativenumber    " toggle hybrid line numbers
" large scrolloff to keep cursor in middle
set scrolloff=999
" Display the cursor position on the last line of the screen
set ruler
" Always display the status line, even if only one window is displayed
set laststatus=2
" Cmd window height to 2 lines to avoid having to press <Enter> to cont.
set cmdheight=2
" Underline current line
set cursorline
" Status line options
set statusline=2						"always show
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
"set statusline +=%2*0x%04B\ %*          "character under cursor
hi User1 guifg=#eea040 guibg=#222222
hi User2 guifg=#dd3333 guibg=#222222
hi User3 guifg=#ff66ff guibg=#222222
hi User4 guifg=#a0ee40 guibg=#222222
hi User5 guifg=#eeee40 guibg=#222222
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Colors, themes, fonts
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
" Set different colorscheme for gui and console
if has('gui_running')
	" Disable menu bar (m) and tool bar (T)
	set guioptions -=m 
	set guioptions-=T 
	set guioptions-=r " scrollbar 
	colorscheme twilight 
else
	colorscheme twilight256 
    hi StatusLine ctermbg=2 ctermfg=8 " overwr status line
endif

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Searching
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Syntax and indentation
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start
" When indented and pressing enter, keep same indent as previous line
set autoindent
" Stop certain movements from always going to the first char of a line
set nostartofline
" Tab = 4 spaces wide
set shiftwidth=4
set tabstop=4
" set softtabstop=4
" After tab has been inserted, replace it with 4 spaces for portab/ity
set expandtab


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Key mappings and shortcuts
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
let mapleader=" "
" Delete without copying
nnoremap <leader>d "_d<cr>
" Exit all w/o saving
inoremap <leader>q <Esc>:qa!<cr>
nnoremap <leader>q :qa!<cr>
" <zz> to save
" <qq> to quit without saving
nnoremap zz :w!<cr>
inoremap zz <Esc>:w!<cr>
nnoremap qq :wq!<cr>
inoremap qq <Esc>:wq!<cr>
" Auto-close bracket by typing it twice or by <bracket><Space> 
inoremap {<CR> {<CR>}<C-o>O
inoremap {<space> {}<Left>
inoremap {{ {}<Left>
inoremap (<space> ()<Left>
inoremap (( ()<Left>
inoremap << <><Left>
inoremap <<space> <><Left>
inoremap [[ []<Left>
inoremap [<space> []<Left>
inoremap "<space> ""<Left>
"inoremap "" ""<Left>
if s:auto_close_brackets!=0
    " see here: https://stackoverflow.com/a/34992101
    inoremap " ""<left>
    inoremap ' ''<left>
    inoremap ( ()<left>
    inoremap [ []<left>
    inoremap { {}<left>
    inoremap {<CR> {<CR>}<ESC>O
    inoremap {;<CR> {<CR>};<ESC>O
endif

imap jj <Esc>
imap hhh <Esc>
imap kkk <Esc>
imap lll <Esc>
" needs stty -ixon in bash profile/ bash rc or unpause with Ctrl+Q
noremap <c-s> :update<CR>
" CtrlP plugin scan directory
noremap<c-p> :CtrlP<CR>

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Filetype (language) specific
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"" C, C++
" add header guard constant
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename . " "
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()
"
" Visual mode select and then comment (/**/) with Backspace
autocmd Filetype c,cpp,h,hpp vnoremap <BS> meomsv`ea */<Esc>`si/* <Esc>`e4l"
autocmd Filetype c,cpp,h,hpp imap <F5> <Esc>:w<CR>:!clear;gcc -std=c99 -lm;./a.out<CR>
autocmd Filetype c,cpp,h,hpp nmap <F5> <Esc>:w<CR>:!clear;gcc -std=c99 -lm;./a.out<CR>

"" Python
" Visual mode select and then comment with Backspace
autocmd Filetype python vnoremap <BS> meomsv`ea """<Esc>`si""" <Esc>`e4l
" Save and run with F5
autocmd Filetype python imap <F5> <Esc>:w<CR>:!clear;python %<CR>
autocmd Filetype python nmap <F5> <Esc>:w<CR>:!clear;python %<CR>

"" Tex
"TODO: make bold, italic, insert figure, insert equation, list...
