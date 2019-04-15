"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" __   _____ __  __ ___  ___
" \ \ / /_ _|  \/  | _ \/ __|
"  \ V / | || |\/| |   / (__
"   \_/ |___|_|  |_|_|_\\___|
"
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Notes :
" 1. If you're editing this file, you can enter :so % to source it
" 2. It is not guaranteed that all commands/ mappings will work on
"    Windows

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) General Controls
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" The more of them are set to 0, the more features are disabled
let s:enable_plugins = 1
let s:auto_close_brackets = 0
let s:use_custom_themes = 1

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Plugins
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
if s:enable_plugins != 0
    "" Pathogen
    execute pathogen#infect()
    "" Syntastic
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
    "" Nerdtree - start automatically
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    let g:NERDTreeWinSize=30 " width
    let g:Tlist_WinWidth=30 " width
    nnoremap <F8> :NERDTreeToggle<CR>
    "" CtrlP plugin
    " CtrlP - fuzzy file search
    set runtimepath^=~/.vim/bundle/ctrlp.vim
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_root_markers = ['pom.xml', '.p4ignore']
    let g:ctrlp_switch_buffer = 'et'
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.gz
    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
    let g:ctrlp_user_command = 'find %s -type f'
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    " CtrlP plugin scan directory - do this to initialise it
    noremap<c-p> :CtrlP<CR>
    "" jedi - reads tags and autocompletes with doc
    "init jedi plugin
    let g:jedi#auto_initialization = 1
    let g:jedi#auto_vim_configuration = 0
    "tabs when going to a definition
    let g:jedi#use_tabs_not_buffers = 1
    "jedi for splits
    let g:jedi#use_splits_not_buffers = "left"
    "" ctags
    " ctags usage: https://robhoward.id.au/blog/2012/03/ctags-with-vim/
    set tags=tags
    "" tagbar (class browser) activation
    nmap <F9> :TagbarToggle<CR>
    "" airline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ' '
    let g:airline#extensions#tabline#left_alt_sep = '|'
    let g:airline#extensions#tabline#formatter = 'default'
    set laststatus=2 " at the bottom
    "" UntiSnips
    "Trigger configuration. Do not use <tab> if you use
    "https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<c-e>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    "" clang-complete
    " IMPORTANT: modify clang path
    " If clang is not ground, try setting the path to something like /usr/lib/llvm-*/lib/
    let g:clang_library_path = '/usr/lib/i386-linux-gnu'
    let g:clang_c_options = '-std=gnu11'
    let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
    let g:clang_complete = 1 "automatically selects the first entry in the popup menu
    let g:clang_snippets = 1 "do some snippets magic on code placehorlders like funcion argument, template parameters, etc.
    let g:clang_close_preview = 1
    "" Snipmate - see installation at https://github.com/garbas/vim-snipmate
endif


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Basic behaviour
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Highlight syntax
syntax on
filetype plugin indent on
" Don't create backup files to avoid potential annoying Q's on opening
set noswapfile
" Don't let OS overwrite VIM settings, re-source .vimrc safely
"set nocompatible
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
" Show matching bracket
set showmatch
" remove buffer when closing tab
set nohidden
" For 256 colour terminals
set t_Co=256

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Text insertion & test misc
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Use <F10> to toggle between 'paste' and 'nopaste' mode
set pastetoggle=<F10>
" Better command-line completion
set wildmenu
" Char encoding, mainly so NERDtree can show arrow symbols
set encoding=utf-8


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Window options & scrolling
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
if s:use_custom_themes==0
    set statusline=2                        "always show
    set statusline +=%1*\ %n\ %*            "buffer number
    set statusline +=%5*%{&ff}%*            "file format
    set statusline +=%3*%y%*                "file type
    set statusline +=%4*\ %<%F%*            "full path
    set statusline +=%2*%m%*                "modified flag
    set statusline +=%1*%=%5l%*             "current line
    set statusline +=%2*/%L%*               "total lines
    set statusline +=%1*%4v\ %*             "virtual column number
endif
" Scroll vertically wrapped line
nmap j gj
nmap k gk
"Don't update screen during macro and script execution.
set lazyredraw
" Automatically re-read files if unmodified inside Vim.
set autoread

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Colors, themes, fonts
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
if  s:use_custom_themes!=0
    " Set different colorscheme for gui and console
    if has('gui_running')
        " Disable menu bar (m) and tool bar (T)
        set guioptions -=m
        set guioptions-=T
        set guioptions-=r " scrollbar
        colorscheme twilight
        set guifont=Source\ Code\ Pro\ 14
    else
        colorscheme twilight256
        hi StatusLine ctermbg=2 ctermfg=8 " overwr status line
    endif
endif
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Searching
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Indentation
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

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Key mappings and shortcuts
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"" Leader mappings
" Define leader key before defininf any shortcut
let mapleader=" "
" Delete without copying
nnoremap <leader>d "_dd
" new line w/o leaving normal mode
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>j
"" Other mappings
" <zz> to save
" <qq> to quit after saving
nnoremap zz :w!<cr>
inoremap zz <Esc>:w!<cr>
nnoremap qq :wq!<cr>
inoremap qq <Esc>:wq!<cr>
" quit all w/o saving - needs stty -ixon in bash profile/ bash rc
nnoremap <C-q> :qa!<cr>
inoremap <C-q> <Esc>:qa!<cr>
" Auto-close bracket by typing it twice or by <bracket><Space>
inoremap {<CR> {<CR>}<C-o>O
inoremap {<space> {}<Left>
inoremap {{ {}<Left>
inoremap (<space> ()<Left>
inoremap (( ()<Left>
inoremap <<space> <><Left>
inoremap [[ []<Left>
inoremap [<space> []<Left>
inoremap "<space> ""<Left>
inoremap '<space> ''<Left>
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
" something overwrote `a` - re-map it to insert at end of line
nmap a $i<Right> 
" Leader+h to auto-highlight word under cursor
nnoremap <leader>h :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" Jump to next pane (I don't use too many)
map <C-l> <C-W>w
imap <C-l> <C-W>w
map <Right> <C-W>w
" Jump to next (gT)/ previous (gt) tab
" noremap <Up> gT
" noremap <Down> gt
" Save with Ctrl+S,
" needs stty -ixon in bash profile/ bash rc or unpause with Ctrl+Q
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR><Esc>:Update<CR>


"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Custom commands
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" Remove trailing whitespaces
command! NoTS :%s/\s\+$//
command! TabsToSpaces :%s/\t/    /g
command! WinToNix :%s/<Ctrl-V><Ctrl-M>/\r/g

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Filetype (language) specific
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

" Visual mode select and then comment (/**/) with Backspace
autocmd Filetype c,cpp,h,hpp vnoremap <BS> meomsv`ea */<Esc>`si/* <Esc>`e4l"
autocmd Filetype c,cpp,h,hpp inoremap <Leader>ii #include <><Esc>i
autocmd Filetype c imap <F5> <Esc>:w<CR>:!clear;gcc % -std=c99 -lm;./a.out<CR>
autocmd Filetype c nmap <F5> <Esc>:w<CR>:!clear;gcc % -std=c99 -lm;./a.out<CR>
autocmd Filetype c,cpp inoremap "" ""<Left>
"" TODO: this should next if the next character is space
autocmd Filetype c,cpp inoremap , ,<space>
"" Python
" Visual mode select and then comment with Backspace
autocmd Filetype python vnoremap <BS> meomsv`ea """<Esc>`si""" <Esc>`e4l
" Save and run with F5
autocmd Filetype python imap <F5> <Esc>:w<CR>:!clear;python %<CR>
autocmd Filetype python nmap <F5> <Esc>:w<CR>:!clear;python %<CR>
" After tab has been inserted, replace it with 4 spaces for portab/ity
autocmd Filetype python set expandtab
" zM, zR, za
autocmd Filetype python set foldmethod=indent
"Disable folding by default
set nofoldenable
" <Leader>b = breakpoint
autocmd Filetype python nnoremap <Leader>b oimport pdb; pdb.set_trace()<Esc>j
" TODO: <Leader>B = delete all breakpoints
autocmd Filetype python inoremap , ,<space>
"" vimrc  o n l y
"auto-source upon saving
autocmd! bufwritepost .vimrc source %
"" Tex
"TODO: make bold, italic, insert figure, insert equation, list...
"" Exceptions
autocmd FileType * if &ft != 'py'| imap "" ""<Left>
autocmd FileType * if &ft != 'py'| imap '' ''<Left>
