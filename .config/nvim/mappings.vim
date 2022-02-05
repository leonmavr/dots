
" Scroll vertically wrapped line
nmap j gj
nmap k gk

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

" Escape insert mode
imap jj <Esc>
imap hhh <Esc>
imap kkk <Esc>

" insert at end of line 
nmap a $i<Right>
" re-select visual block after identing it
vnoremap < <gv
vnoremap > >gv

"" Panes and tabs
" Jump to next pane (I don't use too many)
map <C-l> <C-W>w
imap <C-l> <C-W>w
map <Right> <C-W>w

"" Other mappings
" <zz> to save
" <qq> to quit after saving
nnoremap zz :w!<cr>
inoremap zz <Esc>:w!<cr>
nnoremap qq :wq!<cr>
inoremap qq <Esc>:wq!<cr>
" auto save when leaving insert mode
"autocmd InsertLeave * write
" quit all w/o saving - needs stty -ixon in bash profile/ bash rc
nnoremap <C-q> :qa!<cr>
inoremap <C-q> <Esc>:qa!<cr>


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
autocmd Filetype python imap <F5> <Esc>:w<CR>:!clear;python3 %<CR>
autocmd Filetype python nmap <F5> <Esc>:w<CR>:!clear;python3 %<CR>
" After tab has been inserted, replace it with 4 spaces for portab/ity
autocmd Filetype python set expandtab
" zM, zR, za
autocmd Filetype python set foldmethod=indent
"Disable folding by default
set nofoldenable
" <Leader>b = breakpoint, <Leader>B deletes them all
autocmd Filetype python nnoremap <Leader>b oimport pdb; pdb.set_trace()<Esc>j
autocmd Filetype python nnoremap <Leader>B :g/pdb.set_trace/d<cr>
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
autocmd Filetype sh set expandtab
""Exceptions
autocmd FileType * if &ft != 'py'| imap "" ""<Left>
autocmd FileType * if &ft != 'py'| imap '' ''<Left>
