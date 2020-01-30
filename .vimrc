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
let s:enable_jedi_hack = 1

"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
" (S) Ugly Hacks 
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
"credits https://github.com/davidhalter/jedi-vim/issues/389#issuecomment-279498977
" This one is needed for jedi-vim, which autocompletes
" ESTIMATE PYTHON VERSION, BASED ON THIS WE WILL SIMPLY CALL PY or PY3
" note +python/dyn and +python3/dyn has to be loaded
if s:enable_jedi_hack != 0
	let py_version = system('python -V 2>&1 | grep -Po "(?<=Python )[2|3]"')
	if  py_version == 2
	  python pass
	elseif py_version == 3
	  python3 pass
	else
	  python pass
	endif 
endif

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
	let g:syntastic_python_checkers=['flake8', 'python']
	let g:syntastic_python_flake8_args='--ignore=E114,E116,E121,E122,E123,E124,E125,E126,E127,E128,E129,E131,E133,E201,E202,E211,E221,E222,E225,E226,E227,E228,E231,E242,E251,E261,E262,E265,E266,E271,E272,E273,E274,E301,E302,E303,E304,E401,E402,E701,E702,E704,E713,E731,E902,W191,W292,W503,W601,W602,W603,W604'
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
    let g:jedi#auto_vim_configuration = 1
    "tabs when going to a definition
    let g:jedi#use_tabs_not_buffers = 1
    "jedi for splits
    let g:jedi#use_splits_not_buffers = "left"
	" let g:jedi#force_py_version = 3
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
	let g:airline#extensions#tabline#enabled = 0
    set laststatus=2 " at the bottom
    " the following line needs powerline fonts installed
    let g:airline_powerline_fonts = 1
    "" Airline themes
    let g:airline_powerline_fonts = 1
    "" UntiSnips
    "Trigger configuration. Do not use <tab> if you use
    "https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<c-e>"
    let g:UltiSnipsJumpForwardTrigger="<c-b>"
    let g:UltiSnipsJumpBackwardTrigger="<c-z>"
    "" clang-complete
    " IMPORTANT: modify clang path
    " If clang is not found, try setting the path to something like /usr/lib/llvm-*/lib/
    "let g:clang_library_path = '/usr/lib/llvm-3.8/lib/'
    let g:clang_library_path = '/usr/lib/libclang.so'
    let g:clang_c_options = '-std=gnu11'
    let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
    let g:clang_complete = 1 "automatically selects the first entry in the popup menu
    let g:clang_snippets = 1 "do some snippets magic on code placehorlders like funcion argument, template parameters, etc.
    let g:clang_close_preview = 1
    "" Snipmate - see installation at https://github.com/garbas/vim-snipmate
    "" Goyo - a plugin to remove distractions
    function! s:goyo_enter()
        set scrolloff=999
        Goyo 90%
    endfunction
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    " pressing F7 toggles distractions
    nmap <F7> :Goyo<CR>
    imap <F7> <Esc>:Goyo<CR>i
	"" vim-latex-live-preview
	let g:livepreview_previewer = 'zathura'
	let g:livepreview_engine = 'pdflatex' . ' -shell-escape' . '-synctex=1'
	" Remember: LLPStartPreview compiles it
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
" no visual bell
set noeb vb t_vb=

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
"" Default size
set lines=45 columns=100
"" Show line numbers on the left
set number relativenumber " hybrid line no; show line num, others relative
" More on that:
" set nonumber norelativenumber  " turn hybrid line numbers off
" set !number !relativenumber    " toggle hybrid line numbers
" large scrolloff to keep cursor in middle
set scrolloff=999
"" smooth scrolling - see
" https://www.reddit.com/r/vim/comments/bh6u5q/smooth_scroll_in_vim/
nnoremap <silent> <c-u> :call <sid>smoothScroll(1)<cr>
nnoremap <silent> <c-d> :call <sid>smoothScroll(0)<cr>

fun! s:smoothScroll(up)
  execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
  redraw
  for l:count in range(3, &scroll, 3)
    sleep 4m
    execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
    redraw
  endfor
  " bring the cursor in the middle of screen 
  execute "normal M"
endf
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
" make splits equal size"
set equalalways 
autocmd VimResized * wincmd =

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
        colorscheme nighted 
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
" work with system's clipboard
" NOTE: If `vim --version` gives `-clipboard`,
" 		it is recommended to install gvim to
" 		enable it
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p
vnoremap <Leader>y "*y
vnoremap <Leader>p "*p
vnoremap <Leader>Y "+y
vnoremap <Leader>P "+p

" Surround in brackets
vnoremap <leader>( xi()<Esc>P
vnoremap <leader>) xi()<Esc>P
vnoremap <leader>[ xi[]<Esc>P
vnoremap <leader>] xi[]<Esc>P
vnoremap <leader>" xi""<Esc>P
vnoremap <leader>' xi''<Esc>P
vnoremap <leader>{ xi{}<Esc>P
vnoremap <leader>} xi{}<Esc>P

"" Undo is u. So map redo to U
nnoremap U <C-R>

"" Other mappings
" <zz> to save
" <qq> to quit after saving
nnoremap zz :w!<cr>
inoremap zz <Esc>:w!<cr>
nnoremap qq :wq!<cr>
inoremap qq <Esc>:wq!<cr>
" auto save when leaving insert mode
autocmd InsertLeave * write
" quit all w/o saving - needs stty -ixon in bash profile/ bash rc
nnoremap <C-q> :qa!<cr>
inoremap <C-q> <Esc>:qa!<cr>
" Auto-close bracket by typing it twice or by <bracket><Space>
inoremap {<CR> {<CR>}<C-o>O
inoremap {<space> {}<Left>
inoremap {{ {}<Left>
inoremap (<space> ()<Left>
inoremap (( ()<Left>
inoremap )) ()<Left>
inoremap [[ []<Left>
inoremap ]] []<Left>
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
" something overwrote a
nmap a $i<Right>
" re-select visual block after identing it
vnoremap < <gv
vnoremap > >gv
" Leader+h to auto-highlight word under cursor
nnoremap <leader>h :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=2000
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

"" Panes and tabs
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
autocmd Filetype c imap <F5> <Esc>:w<CR>:!clear;gcc % -g -std=c99 -lm;./a.out<CR>
autocmd Filetype c nmap <F5> <Esc>:w<CR>:!clear;gcc % -g -std=c99 -lm;./a.out<CR>
autocmd Filetype c imap <F6> <Esc>:w<CR>:!clear;gcc % -g -std=c99 -lm;gdb -q a.out<CR>
autocmd Filetype c nmap <F6> <Esc>:w<CR>:!clear;gcc % -g -std=c99 -lm;gdb -q a.out<CR>
autocmd Filetype c,cpp inoremap "" ""<Left>
"" TODO: this should next if the next character is space
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
" <Leader>b = breakpoint, <Leader>B deletes them all
autocmd Filetype python nnoremap <Leader>b oimport pdb; pdb.set_trace()<Esc>j
autocmd Filetype python nnoremap <Leader>B :g/pdb.set_trace/d<cr>
" TODO: <Leader>B = delete all breakpoints
"" vimrc  o n l y
"auto-source upon saving
autocmd! bufwritepost .vimrc source %
"" Tex
autocmd FileType tex inoremap $$ $$<Left>
autocmd FileType tex inoremap \[ \[<esc>o<esc>o<bs>\]<esc>ki<tab>
autocmd FileType tex vnoremap ,$ xi$$<Esc>P
autocmd FileType tex vnoremap ,b xi\textbf{}<Esc>P
autocmd FileType tex vnoremap ,i xi\textit{}<Esc>P
autocmd FileType tex setlocal spell spelllang=en_uk
autocmd Filetype tex inoremap <F5> <esc>:w!<cr>:LLPStartPreview<cr>
autocmd Filetype tex nnoremap <F5> :w!<cr>:LLPStartPreview<cr>
autocmd Filetype tex inoremap <F6> <esc>:!pdflatex -shell-escape %<cr>
nnoremap <F6> :!pdflatex -shell-escape %<cr>
" : included in words for easier referencing
autocmd Filetype tex set iskeyword+=:
"" Bash
autocmd Filetype sh inoremap <F5> <esc>:w!<cr>:!clear;bash %<cr>
autocmd Filetype sh noremap <F5> :w!<cr>:!clear;bash %<cr>
autocmd Filetype sh imap `` ``<esc>i
""Exceptions
autocmd FileType * if &ft != 'py'| imap "" ""<Left>
autocmd FileType * if &ft != 'py'| imap '' ''<Left>

