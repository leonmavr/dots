" Name:       synthwave-neon.vim
" Version:    0.1.0
" Maintainer: adapted from sunbather.vim
" Created by: ChatGPT with some tweaks
" License:    The MIT License (MIT)
"
" Synthwave-inspired colorscheme for Vim and Neovim.
" Neon cyan, fuchsia, mint, magenta and purple tones on a dark background.
"

hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='synthwave-neon'

" ─────────────────────────────────────────────
" Palette
" ─────────────────────────────────────────────
let s:black        = { "gui": "#0a0014", "cterm": "232" }
let s:cyan         = { "gui": "#03CDFF", "cterm": "14"  }
let s:fuchsia      = { "gui": "#FF5ACD", "cterm": "205" }
let s:mint         = { "gui": "#36F5E2", "cterm": "43"  }
let s:violet       = { "gui": "349ae3" , "cterm": "135" }
let s:green        = { "gui": "#1CE69A", "cterm": "10"  }
let s:offwhite     = { "gui": "#faaac1", "cterm": "15"  }
let s:gray         = { "gui": "#cbb1cc", "cterm": "252" }
let s:dark_gray    = { "gui": "#1a1a1a", "cterm": "234" }

let s:bg           = s:black
let s:bg_subtle    = s:dark_gray
let s:norm         = s:offwhite
let s:norm_subtle  = s:gray

" ─────────────────────────────────────────────
" Highlight helper
" ─────────────────────────────────────────────
function! s:h(group, style)
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
    \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
    \ "ctermfg=" (has_key(a:style, "fg")    ? a:style.fg.cterm : "NONE")
    \ "ctermbg=" (has_key(a:style, "bg")    ? a:style.bg.cterm : "NONE")
    \ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

" ─────────────────────────────────────────────
" Core
" ─────────────────────────────────────────────
call s:h("Normal",        {"bg": s:bg, "fg": s:norm})
call s:h("Comment",       {"fg": s:gray, "gui": "italic"})

call s:h("Constant",      {"fg": s:green})
call s:h("String",        {"fg": s:fuchsia})
call s:h("Number",        {"fg": s:offwhite})
call s:h("Float",         {"fg": s:offwhite})
call s:h("Boolean",       {"fg": s:offwhite})
call s:h("Character",     {"fg": s:offwhite})

call s:h("Identifier",    {"fg": s:violet})     " Variables
call s:h("Function",      {"fg": s:cyan})       " Function names

call s:h("Type",          {"fg": s:mint})
call s:h("Statement",     {"fg": s:violet})
call s:h("Operator",      {"fg": s:cyan, "gui": "bold"})
call s:h("PreProc",       {"fg": s:violet})
call s:h("Special",       {"fg": s:fuchsia})
call s:h("Underlined",    {"fg": s:mint, "gui": "underline"})
call s:h("Error",         {"fg": s:offwhite, "bg": s:violet, "gui": "bold"})
call s:h("Todo",          {"fg": s:fuchsia, "gui": "underline"})

" ─────────────────────────────────────────────
" UI elements
" ─────────────────────────────────────────────
call s:h("LineNr",        {"fg": s:gray})
call s:h("CursorLineNr",  {"fg": s:fuchsia, "bg": s:bg_subtle})
call s:h("StatusLine",    {"bg": s:bg_subtle, "fg": s:mint})
call s:h("StatusLineNC",  {"bg": s:bg_subtle, "fg": s:gray})
call s:h("VertSplit",     {"fg": s:bg_subtle})
call s:h("Visual",        {"bg": s:violet, "fg": s:offwhite})
call s:h("Search",        {"bg": s:green, "fg": s:black})
call s:h("IncSearch",     {"bg": s:cyan, "fg": s:black})
call s:h("Directory",     {"fg": s:mint})
call s:h("WarningMsg",    {"fg": s:violet})
call s:h("ErrorMsg",      {"fg": s:fuchsia})
call s:h("SignColumn",    {"fg": s:gray})
call s:h("Pmenu",         {"fg": s:norm, "bg": s:bg_subtle})
call s:h("PmenuSel",      {"fg": s:black, "bg": s:cyan})
call s:h("CursorLine",    {"bg": s:bg_subtle})
call s:h("ColorColumn",   {"bg": s:bg_subtle})
call s:h("MatchParen",    {"bg": s:violet, "fg": s:offwhite, "gui": "bold"})
call s:h("Folded",        {"fg": s:gray})
call s:h("FoldColumn",    {"fg": s:gray})

" ─────────────────────────────────────────────
" Plugins (optional defaults)
" ─────────────────────────────────────────────
hi link GitGutterAdd DiffAdd
hi link GitGutterChange DiffChange
hi link GitGutterDelete DiffDelete

call s:h("DiffAdd",       {"fg": s:green})
call s:h("DiffDelete",    {"fg": s:fuchsia})
call s:h("DiffChange",    {"fg": s:violet})
call s:h("DiffText",      {"fg": s:cyan})
