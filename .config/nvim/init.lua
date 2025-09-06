-------------------------------------------------------------------------------
-- Requirements
-------------------------------------------------------------------------------

-- # LSP
-- sudo npm install -g pyright

-- # Python tools
-- pip install black flake8 debugpy

-------------------------------------------------------------------------------
-- Behavior 
-------------------------------------------------------------------------------
vim.g.mapleader = " "       -- Set the leader key to space
vim.g.maplocalleader = " "  -- Set the local leader key to space
vim.o.swapfile = false

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

-------------------------------------------------------------------------------
-- Maps 
-------------------------------------------------------------------------------
-- Bracket autocompletion
vim.keymap.set('i', '((', function() return '()<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '))', function() return '()<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '[[', function() return '[]<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', ']]', function() return '[]<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '{{', function() return '{}<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '}}', function() return '{}<Left>' end, { expr = true, noremap = true })

-- { <enter = { <newline> <tab> <cursor> }
vim.api.nvim_set_keymap("i", "{<CR>", "{<CR>}<Esc>O", { noremap = true })

---- For nvim-dap (debugging)
-- Interact with clipboard
vim.keymap.set("v", "<Leader>Y", '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+p', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>9', function() require'dap'.toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>5', function() require'dap'.continue() end)
vim.keymap.set('n', '<Leader>1', function() require'dap'.step_over() end)
vim.keymap.set('n', '<Leader>2', function() require'dap'.step_into() end)
vim.keymap.set('n', '<Leader>3', function() require'dap'.step_out() end)

-- quickly switch between source/header
vim.keymap.set('n', '<Leader>o', ':ClangdSwitchSourceHeader<CR>', { noremap=true, silent=true })



-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
-- Ensure packer is installed - if not, install it
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1',
      'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'       -- Package manager
  use 'neovim/nvim-lspconfig'        -- LSP support
  use 'hrsh7th/nvim-cmp'             -- Completion framework
  use 'hrsh7th/cmp-nvim-lsp'         -- LSP completions
  use 'L3MON4D3/LuaSnip'             -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'     -- Snippet completions
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-lua/plenary.nvim'        -- Dependency for many plugins
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'preservim/nerdtree'           -- File explorer
  use 'tpope/vim-fugitive'           -- Git integration
  use 'hrsh7th/cmp-buffer'           -- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path'             -- Path completion
  use 'hrsh7th/cmp-cmdline'          -- Command-line completion
  use 'rafamadriz/friendly-snippets' -- Predefined snippets for common languages

  use {
    "mfussenegger/nvim-dap",         -- Debugging
    requires = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio"        -- REQUIRED by nvim-dap-ui
    }
  }
 
  use 'mfussenegger/nvim-lint'       -- Modern linting
  use 'stevearc/conform.nvim'        -- Formatting
  use 'jose-elias-alvarez/null-ls.nvim' -- Extra linting/formatting (optional)
  use 'ray-x/lsp_signature.nvim'     -- Python function signatures
  use {
      'heavenshell/vim-pydocstring', -- Docstring generation for Python
      ft = 'python',
      run = 'make install'
  }
  use {
    'akinsho/toggleterm.nvim',
    tag = '*',
    config = function()
      require("toggleterm").setup()
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-------------------------------------------------------------------------
-- Python development
-------------------------------------------------------------------------
-- Python LSP (Pyright)
local lspconfig = require('lspconfig')

lspconfig.pyright.setup {
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",   -- or "strict" for more errors
        autoImportCompletions = true,
      },
    },
  },
}

-- Enhanced rename with optional switch to source/header
vim.keymap.set('n', '<leader>rn', function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Trigger LSP rename
    vim.lsp.buf.rename()
    -- After rename, offer to switch to source/header
    vim.defer_fn(function()
        local choice = vim.fn.input("Switch to source/header? (y/N): ")
        if choice:lower() == 'y' then
            vim.cmd("ClangdSwitchSourceHeader")
        end
    end, 100)  -- delay slightly to wait for rename to finish
end, { noremap = true, silent = true })


-- Capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Apply to pyright
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
      },
    },
  },
}

require('lint').linters_by_ft = {
  python = { 'flake8' },  -- or 'pylint'
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

require("conform").setup({
  formatters_by_ft = {
    python = { "black" },
  },
})

-- Auto-format Python on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py" },
  callback = function() require("conform").format() end,
})

-- Show signature help in insert mode (C^h)
vim.keymap.set('i', '<C-h>', function()
    vim.lsp.buf.signature_help()
end, { noremap = true, silent = true })

require("lsp_signature").setup({
    bind = true, -- mandatory
    floating_window = true,
    hint_prefix = "💡 ",
    handler_opts = { border = "rounded" },
    always_trigger = true,
})

-- Set the docstring formatter to numpy
vim.g.pydocstring_formatter = 'numpy'

-- Map <Leader>d in normal mode to trigger pydocstring
vim.keymap.set('n', '<Leader>_', '<Plug>(pydocstring)', { noremap = false, silent = true })

-------------------------------------------------------------------------
-- For C/C++ development
-------------------------------------------------------------------------
-- Automatic header guards for .h/.hpp files
local api = vim.api
api.nvim_create_autocmd('BufNewFile', {
  pattern = { '*.h', '*.hpp' },
  callback = function()
    local fname = vim.fn.expand('%:t')
    local base  = vim.fn.fnamemodify(fname, ':r')
    local ext   = vim.fn.expand('%:e')
    local base_guard = base:gsub('%W', '_'):upper()
    local guard = '_' .. base_guard .. '_' .. ext:upper()
    local lines = {
      '#ifndef ' .. guard,
      '#define ' .. guard,
      '',
      '',
      '',
      '#endif // ' .. guard
    }
    api.nvim_buf_set_lines(0, 0, -1, false, lines)
    api.nvim_win_set_cursor(0, {3, 0})
  end,
})

---- LSP clangd
-- LSP clangd
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
  on_attach = function(_, bufnr)
      local opts = { noremap=true, silent=true, buffer=bufnr }

      -- Existing keymaps
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)        -- rename
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)   -- code actions

      -- clangd specific
      vim.keymap.set('n', '<leader>sh', ':ClangdSwitchSourceHeader<CR>', opts)  -- switch source/header
      vim.keymap.set('n', '<leader>ih', ':ClangdToggleInlayHints<CR>', opts)    -- toggle inlay hints

      -- Enable inlay hints initially
      if vim.lsp.buf.inlay_hint then
          vim.lsp.buf.inlay_hint(bufnr, true)
      end
  end,
}

---- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "python" },
  highlight = { enable = true },
}

---- Completion (cmp)
local cmp = require'cmp'
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, { { name = 'buffer' } })
})

---- ALE (linters, formatters)
vim.g.ale_linters = { ['c'] = { 'clang' }, ['cpp'] = { 'clang' } }
vim.g.ale_fixers = { ['c'] = {}, ['cpp'] = {} } -- Disabled clang-format
vim.g.ale_cpp_clangformat_executable = ''
vim.g.ale_fix_on_save = 0

-- Format on save (LSP)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp" },
  -- callback = function() vim.lsp.buf.format() end,
  callback = function() end,  -- empty function, does nothing
})

---- Debugging (dap)
local dap = require('dap')
dap.adapters.cppdbg = {
  type = 'executable',
  command = '/path/to/OpenDebugAD7', -- Change to your debugger path
  name = "cppdbg"
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = false,
    setupCommands = {
      { text = '-enable-pretty-printing', description = 'Enable GDB pretty printing', ignoreFailures = false },
    },
  },
}

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end


---- Telescope mappings
require('telescope').setup{}
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })

---- Snippets
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
vim.keymap.set({ "i", "s" }, "<C-e>", function()
    if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<S-C-e>", function()
    if luasnip.jumpable(-1) then luasnip.jump(-1) end
end, { silent = true })

---- toggleterm plugin options

require("toggleterm").setup {
  size = 10,
  open_mapping = [[<C-t>]],  -- now Ctrl+T toggles the terminal
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = 'horizontal',  -- or 'vertical' | 'tab'
}


---- Toggleable status line with the error
-- Store the current toggle state
local error_line_visible = false
local last_error_msg = ""

-- Function to get the first LSP diagnostic for current line
local function get_current_line_error()
    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- zero-indexed
    local diagnostics = vim.diagnostic.get(bufnr, {lnum = line})
    if diagnostics[1] then
        return diagnostics[1].message
    end
    return ""
end

---- Toggleable floating window for LSP diagnostics (syntax errors etc.)
local float_win = nil
local float_buf = nil

local function toggle_lsp_float()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1] - 1
    local col = cursor[2]

    -- If window already exists, close it
    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
        float_win = nil
        float_buf = nil
        return
    end

    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
    if not diagnostics[1] then return end

    local msg = diagnostics[1].message

    -- Create buffer
    float_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, vim.split(msg, "\n"))

    -- Floating window options
    local width = math.min(60, math.max(20, #msg))
    local height = #vim.split(msg, "\n")
    local opts = {
        relative = "cursor",
        row = 1,
        col = 2,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
    }

    float_win = vim.api.nvim_open_win(float_buf, false, opts)
    vim.api.nvim_win_set_option(float_win, "winhl", "Normal:ErrorMsg")
end

-- Map C^h to a popup window showing warnings/errors
vim.keymap.set("n", "<C-h>", toggle_lsp_float, { noremap = true, silent = true })

-------------------------------------------------------------------------
-- Status line
-------------------------------------------------------------------------

-- Highlight: main text block
vim.api.nvim_set_hl(0, 'LeftHighlight', {
  fg = '#000000', -- black text
  bg = '#f51187',
  bold = true,
})

-- Gradient block 1 (slightly darker than magenta)
vim.api.nvim_set_hl(0, 'LeftGrad1', {
  fg = '#c40e6c',
  bg = 'NONE',
})

-- Gradient block 2 (even darker)
vim.api.nvim_set_hl(0, 'LeftGrad2', {
  fg = '#930b52',
  bg = 'NONE',
})

-- Gradient block 3 (even darker)
vim.api.nvim_set_hl(0, 'LeftGrad3', {
  fg = '#6c083b',
  bg = 'NONE',
})

-- Highlight: main text block
vim.api.nvim_set_hl(0, 'RightHighlight', {
  fg = '#000000', -- black text
  bg = '#4cdef5',
  bold = true,
})

-- Gradient block 1 (slightly darker than magenta)
vim.api.nvim_set_hl(0, 'RightGrad1', {
  fg = '#3dabc4',
  bg = 'NONE',
})

-- Gradient block 2 (even darker)
vim.api.nvim_set_hl(0, 'RightGrad2', {
  fg = '#2e8192',
  bg = 'NONE',
})

-- Gradient block 3 (even darker)
vim.api.nvim_set_hl(0, 'RightGrad3', {
  fg = '#1e565f',
  bg = 'NONE',
})


local function blockleft(text)
  return table.concat({
    "%#LeftGrad3#█",
    "%#LeftGrad2#█",
    "%#LeftGrad1#█",
    "%#LeftHighlight# " .. text .. " ",
    "%#LeftGrad1#█",
    "%#LeftGrad2#█",
    "%#LeftGrad3#█",
    "%#Normal#"
  })
end

local function blockright(text)
  return table.concat({
    "%#RightGrad3#█",
    "%#RightGrad2#█",
    "%#RightGrad1#█",
    "%#RightHighlight# " .. text .. " ",
    "%#RightGrad1#█",
    "%#RightGrad2#█",
    "%#RightGrad3#█",
    "%#Normal#"
  })
end

-- Git branch for the file's directory
local function get_git_branch_for_file()
  local filepath = vim.fn.expand("%:p")
  local filedir = vim.fn.fnamemodify(filepath, ":h")

  -- Use `git -C <dir>` to query from file's directory
  local cmd = string.format("git -C '%s' rev-parse --abbrev-ref HEAD 2>/dev/null", filedir)
  local handle = io.popen(cmd)
  if handle then
    local result = handle:read("*l") or ""
    handle:close()
    return result
  end
  return ""
end

local function get_mode()
  local modes = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",  -- CTRL-V
    c = "COMMAND",
    R = "REPLACE",
    t = "TERMINAL",
  }
  local mode = vim.fn.mode()
  return modes[mode] or mode
end


function _G.custom_statusline()
  local mode = get_mode()

  local filename = vim.fn.expand("%:t")
  if filename == "" then filename = "[No Name]" end

  local line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local col = vim.fn.col(".")
  local position = string.format("%d/%d, %d", line, total_lines, col)

  local filetype = vim.bo.filetype
  if filetype == "" then filetype = "no ft" end

  local branch = get_git_branch_for_file()

  -- Left-aligned blocks
  local left = table.concat({
    blockleft(mode),
    "  ",
    blockleft(filename),
    "  ",
    blockleft(position),
  })

  -- Right-aligned blocks
  local right = blockright(filetype)
  if branch ~= "" then
    right = right .. "  " .. blockright(branch)
  end

  return left .. " %= " .. right
end


vim.o.statusline = "%!v:lua.custom_statusline()"

-------------------------------------------------------------------------------
-- Smooth scrolling with <C-d> / <C-u>
-------------------------------------------------------------------------------
local scrolling = false

local function smooth_scroll(direction)
  if scrolling then return end  -- prevent stacking animations
  scrolling = true

  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local bufnr = vim.api.nvim_get_current_buf()
  local total_lines = vim.api.nvim_buf_line_count(bufnr)

  local win_height = vim.api.nvim_win_get_height(win)
  local step = math.floor(win_height / 2)

  local line = cursor[1]
  local col = cursor[2]
  local i = 0

  local function scroll_step()
    if i >= step then
      scrolling = false
      return
    end
    if direction == "down" then
      if line + 10 >= total_lines then
        scrolling = false
        return
      end
      line = line + 1
    else
      line = math.max(1, line - 1)
    end
    vim.api.nvim_win_set_cursor(win, { line, col })
    vim.cmd("redraw")
    i = i + 1
    -- defer_fn to make it non-blocking
    vim.defer_fn(scroll_step, 10) -- in ms
  end

  scroll_step()
end

vim.keymap.set("n", "<C-d>", function() smooth_scroll("down") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", function() smooth_scroll("up") end, { noremap = true, silent = true })
