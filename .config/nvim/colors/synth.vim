" Name:       synthwave-neon.vim
" Version:    0.1
" Maintainer: adapted from sunbather.vim
" Author: ChatGPT with some tweaks
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
" Color palette
" ─────────────────────────────────────────────
let s:black           = { "gui": "#0a0014", "cterm": "232" }
let s:deep_purple     = { "gui": "#2a004f", "cterm": "55"  }
let s:bright_purple   = { "gui": "#9d4edd", "cterm": "135" }
let s:fuchsia         = { "gui": "#ff00aa", "cterm": "199" }
let s:magenta         = { "gui": "#ff4dd2", "cterm": "205" }
let s:cyan            = { "gui": "#00fff7", "cterm": "14"  }
let s:mint            = { "gui": "#11edba", "cterm": "43"  }     " types
let s:neon_green      = { "gui": "#39ff14", "cterm": "10"  }
let s:offwhite        = { "gui": "#c7fcec", "cterm": "195" }     " numbers
let s:var_pink        = { "gui": "#fc6ae4", "cterm": "213" }     " variables
let s:linenr_gray     = { "gui": "#cef0d9", "cterm": "152" }     " new line number color
let s:yellow          = { "gui": "#faff00", "cterm": "226" }
let s:white           = { "gui": "#f0f0f0", "cterm": "15"  }
let s:gray            = { "gui": "#707070", "cterm": "243" }
let s:dark_gray       = { "gui": "#1a1a1a", "cterm": "234" }
let s:light_gray      = { "gui": "#c8c8c8", "cterm": "250" }

" ─────────────────────────────────────────────
" Background logic
" ─────────────────────────────────────────────
let s:background = &background
if &background == "dark"
  let s:bg              = s:black
  let s:bg_subtle       = s:deep_purple
  let s:bg_very_subtle  = s:dark_gray
  let s:norm            = s:white
  let s:norm_subtle     = s:gray
else
  let s:bg              = s:white
  let s:bg_subtle       = s:light_gray
  let s:bg_very_subtle  = s:gray
  let s:norm            = s:dark_gray
  let s:norm_subtle     = s:gray
endif

" ─────────────────────────────────────────────
" Helper
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
" Syntax groups
" ─────────────────────────────────────────────
call s:h("Constant",      {"fg": s:fuchsia})
call s:h("Number",        {"fg": s:offwhite})
call s:h("Float",         {"fg": s:offwhite})
call s:h("Boolean",       {"fg": s:offwhite})
call s:h("Character",     {"fg": s:offwhite})
call s:h("String",        {"fg": s:fuchsia})

call s:h("Identifier",    {"fg": s:var_pink})
call s:h("Function",      {"fg": s:cyan})
call s:h("Type",          {"fg": s:mint})

" ─────────────────────────────────────────────
" UI Elements
" ─────────────────────────────────────────────
call s:h("LineNr",        {"fg": s:linenr_gray})
call s:h("CursorLineNr",  {"fg": s:fuchsia, "bg": s:bg_very_subtle})
call s:h("StatusLine",    {"bg": s:bg_subtle, "fg": s:mint})
call s:h("StatusLineNC",  {"bg": s:bg_subtle, "fg": s:gray})
call s:h("VertSplit",     {"fg": s:deep_purple})
call s:h("Visual",        {"bg": s:deep_purple, "fg": s:cyan})
call s:h("Comment",       {"fg": s:gray, "gui": "italic"})

