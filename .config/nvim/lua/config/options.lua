-------------------------------------------------------------------------------
-- Behavior 
-------------------------------------------------------------------------------
vim.g.mapleader = " "       -- Set the leader key to space
vim.g.maplocalleader = " "  -- Set the local leader key to space

-- when re-opening a file, open from last edit location
vim.o.undofile = true
vim.o.shada = "'1000,f1,h"
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd("normal! g`\"")
    end
  end
})

-- Tabs to 4 spaces
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smarttab = true
-- ... unless it's a Makefile or Python file
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "make" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
    end,
})

-- completely disable the mouse
vim.opt.mouse = ""

-- Hybrid absolute and relative line numbering
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 999 -- keep the cursor centered horizontally 

-- no swap files
vim.opt.swapfile = false

-- Text wrapping at 80 characters
vim.opt.textwidth = 80
vim.opt.colorcolumn = "80"
-- Auto wrap while typing in insert mode
vim.opt.formatoptions:append { "t" }

-- case-insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- navigation and basic commands in greek layout
vim.opt.langmap = "ωv,δd,ςw,βb,υy,πp,λl,ιi,κk,ξj,ηh,¨:"

-- working folds for Latex
vim.api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.LaTeXFoldExpr()"
    vim.opt_local.foldlevel = 99
  end,
})

function _G.LaTeXFoldExpr()
  local line = vim.fn.getline(vim.v.lnum)

  if line:match("\\begin%s*{") then
    return "a1"
  elseif line:match("\\end%s*{") then
    return "s1"
  else
    return "="
  end
end


