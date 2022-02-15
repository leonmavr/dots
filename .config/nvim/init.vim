"-------------------------------------------------------------------
" Basic behaviour
"-------------------------------------------------------------------
" Current line number with relative numbers above and below
set number relativenumber
set encoding=utf-8
" TextEdit might fail if hidden is not set.
set hidden
" Dark background for syntax highlighting
set background=dark
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Tab options
"set autoindent             " Indent according to previous line.
set expandtab              " Use spaces instead of tabs.
set softtabstop=4          " Tab key indents by 4 spaces.
set shiftwidth=4           " >> indents by 4 spaces.
set tabstop=4
set shiftround             " >> indents to next multiple of 'shiftwidth'.
" ignore case when searching
set ignorecase
set smartcase
set incsearch		" automatically jump to search match
" large scrolloff to keep cursor in the middle
set scrolloff=999
" open file where I left off
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set noswapfile

"-------------------------------------------------------------------
" Mappings
"-------------------------------------------------------------------
source $HOME/.config/nvim/mappings.vim

"-------------------------------------------------------------------
" Plugins installations
"-------------------------------------------------------------------
" Remember to issue :PlugInstall after adding vim-plugin plugins
" The directory where plugins are installed is ~/.vim/plugged as listed below

" Needs vim-plugin - install as:
"    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Needs also pynvim - install as:
" python3 -m pip install --user --upgrade pynvim
" For syntax checking in C/C++ install ccls and read:
" https://github.com/MaskRay/ccls/wiki/Project-Setup#example-b
call plug#begin('~/.config/nvim/plugged')
    " Once you install coc, e.g for json, python, C/C++ support:
    " :CocInstall coc-json coc-python
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jiangmiao/auto-pairs', {'branch': 'master'}
    " jedi conflicts with Coc. Therefore when opening a .py file, do :CocDisable
    Plug 'davidhalter/jedi-vim', {'branch': 'master'}
    "Plug 'neoclide/coc-jedi', {'do': 'yarn install'}
    Plug 'sirver/UltiSnips', {'branch': 'master'}
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'jremmen/vim-ripgrep'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
    Plug 'heavenshell/vim-pydocstring', { 'do': 'make install', 'for': 'python' }
    Plug 'cpiger/NeoDebug'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'majutsushi/tagbar'
    Plug 'vim-scripts/DrawIt'
    Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
    Plug 'vim-scripts/DoxygenToolkit.vim'
    Plug 'nvie/vim-flake8'
    Plug 'gogoprog/vim-makefile-manager'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    " Colour schemes
    Plug 'Badacadabra/vim-archery'
    Plug 'whatyouhide/vim-gotham'
    Plug 'fcpg/vim-orbital'
    Plug 'cocopon/iceberg.vim'
    Plug 'shadorain/shadotheme'
    Plug 'axvr/photon.vim'
call plug#end()


"-------------------------------------------------------------------
" Plugins configs
"-------------------------------------------------------------------
" --> coc
" language server for autocompletion
source $HOME/.config/nvim/plug-config/coc.vim
" --> Jedi
let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1
"tabs when going to a definition
let g:jedi#use_tabs_not_buffers = 1
"jedi for splits
let g:jedi#use_splits_not_buffers = "left"
" disable Coc on Python file startup because it conflicts with Jedi
au BufEnter *.py CocDisable
" --> UltiSnips
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" --> snipmate
let g:snipMate = { 'snippet_version' : 1 }
" --> pydocstring
let g:pydocstring_formatter = 'numpy'
" --> NeoDebug
"  options
let g:neodbg_debugger              = 'gdb'           " gdb,pdb,lldb
let g:neodbg_gdb_path              = '/usr/bin/gdb'  " gdb path
let g:neodbg_cmd_prefix            = 'DBG'           " default command prefix
let g:neodbg_console_height        = 15              " gdb console buffer hight, Default: 15
let g:neodbg_openbreaks_default    = 1               " Open breakpoints window, Default: 1
let g:neodbg_openstacks_default    = 0               " Open stackframes window, Default: 0
let g:neodbg_openthreads_default   = 0               " Open threads window, Default: 0
let g:neodbg_openlocals_default    = 1               " Open locals window, Default: 1
let g:neodbg_openregisters_default = 0               " Open registers window, Default: 0
" keymaps
let g:neodbg_keymap_toggle_breakpoint  = '<F9>'         " toggle breakpoint on current line
let g:neodbg_keymap_next               = '<F10>'        " next
let g:neodbg_keymap_run_to_cursor      = '<C-F10>'      " run to cursor (tb and c)
let g:neodbg_keymap_jump               = '<C-S-F10>'    " set next statement (tb and jump)
let g:neodbg_keymap_step_into          = '<F11>'        " step into
let g:neodbg_keymap_step_out           = '<S-F11>'      " setp out
let g:neodbg_keymap_continue           = '<F5>'         " run or continue
let g:neodbg_keymap_print_variable     = '<C-P>'        " view variable under the cursor
let g:neodbg_keymap_stop_debugging     = '<S-F5>'       " stop debugging (kill)
let g:neodbg_keymap_toggle_console_win = '<F6>'         " toggle console window
let g:neodbg_keymap_terminate_debugger = '<C-C>'        " terminate debugger
" --> Airline
" use good old status line syntax, e.g.
"let g:airline_section_a = 'test'
"let g:airline_section_b = airline#section#create(['branch'])
let g:airline#extensions#whitespace#enabled = 0 " that was section_z
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
" let g:airline_left_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
" let g:airline_right_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" --> markdown-preview
let g:mkdp_auto_start = 1
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = '127.0.0.1'
let g:mkdp_browser = 'Brave'
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
let g:mkdp_filetypes = ['markdown']

"  Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" --> vim-latex-live-preview
" Use :LLPStartPreview
"-------------------------------------------------------------------
" Colours
"-------------------------------------------------------------------
colorscheme pixelmuerto 
" transparent background
hi Normal guibg=NONE ctermbg=NONE
let g:airline_theme='iceberg'


" Custom commands
"
" credits https://stackoverflow.com/a/7205746
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(values(buffer_numbers))
endfunction
