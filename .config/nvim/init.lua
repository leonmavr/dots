-------------------------------------------------------------------------------
-- Requirements
-------------------------------------------------------------------------------

-- # LSP
-- sudo npm install -g pyright

-- # Python tools
-- pip install black flake8 debugpy

-- # for Telescope (optional)
-- fd-find (Ubuntu/Debian) / fd (Arch)
-- rg

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

-- case-insensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-------------------------------------------------------------------------------
-- Maps 
-------------------------------------------------------------------------------
-- Bracket/quote autocompletion
vim.keymap.set('i', '((', function() return '()<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '))', function() return '()<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '[[', function() return '[]<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', ']]', function() return '[]<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '{{', function() return '{}<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '}}', function() return '{}<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', '""', function() return '""<Left>' end, { expr = true, noremap = true })
vim.keymap.set('i', "''", function() return "''<Left>" end, { expr = true, noremap = true })

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

-- nagivate across long wrapped lines
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- quickly escape
vim.api.nvim_set_keymap('i', 'kkk', '<Esc>', { noremap = true })

-- <Leader>w = save
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })

-- <Leader>q = quit without saving
vim.keymap.set('n', '<Leader>q', ':q!<CR>', { noremap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

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
  use 'lvimuser/lsp-inlayhints.nvim' -- LSP warnings
  use 'L3MON4D3/LuaSnip'             -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'     -- Snippet completions
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-lua/plenary.nvim'        -- Dependency for many plugins

  require('telescope').setup {
    defaults = {
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
      file_ignore_patterns = {},     -- explore hidden files 
      vimgrep_arguments = {
        'rg',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case'
      },
    },
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
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
    'akinsho/toggleterm.nvim',       -- Toggle the terminal
    tag = '*',
    config = function()
      require("toggleterm").setup()
    end
  }

  use({
    "iamcco/markdown-preview.nvim",  -- Preview markdown docs
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  use 'nvim-treesitter/nvim-treesitter-context' -- Current function/method info

  use {
    "SmiteshP/nvim-navbuddy",
    requires = {
        "neovim/nvim-lspconfig",
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
        "numToStr/Comment.nvim",        -- Optional
        "nvim-telescope/telescope.nvim" -- Optional
    }
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

-- Capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- LSP keymaps
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

-- Shared on_attach for Python (Pyright)
local function pyright_on_attach(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- Default LSP keymaps
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

    -- Attach Navbuddy
    require("nvim-navbuddy").attach(client, bufnr)
end

-- Pyright setup with Navbuddy
require("lspconfig").pyright.setup {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = pyright_on_attach,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",   -- or "strict"
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



local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  -- bundled + limit-results make autocompletion faster
  cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--limit-results=20"},
  init_options = {
    fallbackFlags = { "-Wall", "-Wextra", "-std=c++17" },
  },
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

-- shared on_attach for clangd
-- in case plugins like navbuddy need to use it
local function clangd_on_attach(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    -- Default keymaps
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)        -- rename
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)   -- code actions

    -- Clangd specific
    vim.keymap.set('n', '<leader>sh', ':ClangdSwitchSourceHeader<CR>', opts)
    vim.keymap.set('n', '<leader>ih', ':ClangdToggleInlayHints<CR>', opts)

    -- Enable inlay hints initially
    if vim.lsp.buf.inlay_hint then
        vim.lsp.buf.inlay_hint(bufnr, true)
    end

    -- Attach Navbuddy
    require("nvim-navbuddy").attach(client, bufnr)
end

-- clangd setup with combined config
require("lspconfig").clangd.setup {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--limit-results=20"},
    init_options = {
        fallbackFlags = { "-Wall", "-Wextra", "-std=c++17" },
    },
    on_attach = clangd_on_attach,
}

---- diagnostics plugin
vim.diagnostic.config({
  virtual_text = false,  -- or keep your toggle
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = ">",
    focusable = false,
  },
  -- 🔑 lift the limits:
  max = nil,
  max_per_line = nil,
})

-- vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff5555", bold = true })
-- vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ffaa00", bold = true })
-- vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#00aaff" })
-- vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#55ff55" })

-- Toggle only virtual text for diagnostics (keep signs/underline)
local diagnostics_virtual_text = false

function _G.toggle_diagnostics_virtual_text()
  diagnostics_virtual_text = not diagnostics_virtual_text
  vim.diagnostic.config({
    virtual_text = diagnostics_virtual_text
      and { spacing = 2, prefix = "●" }  -- when ON, show with bullet point
      or false,                          -- when OFF, hide
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

-- toggle inline diagnostics 
vim.keymap.set("n", "<Leader>td", toggle_diagnostics_virtual_text, { noremap = true, silent = true })

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
-- vim.g.ale_fixers = { ['c'] = {}, ['cpp'] = {} } -- Disabled clang-format
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
require('telescope').setup {
  defaults = {
    -- optional tweaks
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
  },
}
require('telescope').load_extension('fzf')
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
  direction = 'tab',  -- 'horizontal' | 'vertical' | 'tab'
  auto_scroll = true,
  scrollback = 10000,
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

---- Toggleable floating window for full LSP diagnostics (syntax errors etc.)
local float_win = nil
local float_buf = nil

local function wrap_text(text, max_width)
    local lines = {}
    for _, line in ipairs(vim.split(text, "\n")) do
        while #line > max_width do
            -- find last space within max_width
            local wrap_at = max_width
            for i = max_width, 1, -1 do
                if line:sub(i,i) == " " then
                    wrap_at = i
                    break
                end
            end
            table.insert(lines, line:sub(1, wrap_at))
            line = line:sub(wrap_at+1):gsub("^%s+", "") -- remove leading spaces
        end
        table.insert(lines, line)
    end
    return lines
end

local function toggle_lsp_float()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1] - 1

    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
        float_win = nil
        float_buf = nil
        return
    end

    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
    if not diagnostics[1] then return end

    local msg = diagnostics[1].message
    local wrapped = wrap_text(msg, 60)  -- max width 60 columns

    float_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, wrapped)

    local opts = {
        relative = "cursor",
        row = 1,
        col = 2,
        width = math.min(60, math.max(20, vim.fn.max(vim.tbl_map(function(l) return #l end, wrapped)))),
        height = #wrapped,
        style = "minimal",
        border = "rounded",
    }

    float_win = vim.api.nvim_open_win(float_buf, false, opts)
    vim.api.nvim_win_set_option(float_win, "winhl", "Normal:ErrorMsg")
end


-- Function to close the LSP float
local function close_lsp_float()
    if float_win and vim.api.nvim_win_is_valid(float_win) then
        vim.api.nvim_win_close(float_win, true)
        float_win = nil
        float_buf = nil
    end
end

-- Auto-close on cursor move in normal and insert modes
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    callback = close_lsp_float
})

-- Map C^h to a popup window showing warnings/errors
vim.keymap.set("n", "<C-h>", toggle_lsp_float, { noremap = true, silent = true })

---- TS context
vim.keymap.set("n", "<Leader>tc", ':TSContext toggle<CR>', { noremap = true, silent = true })

-------------------------------------------------------------------------
-- Status line
-------------------------------------------------------------------------
-- Highlight: main text block
vim.api.nvim_set_hl(0, 'LeftHighlight', {
  fg = '#000000', -- black text
  bg = '#f51187',
  bold = true,
})
-- Gradient block 1 (slightly darker then main)
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

-- Inactive left block (greyed out)
vim.api.nvim_set_hl(0, 'InactiveLeftHighlight', { fg = '#aaaaaa', bg = '#333333', bold = true })
vim.api.nvim_set_hl(0, 'InactiveLeftGrad1',    { fg = '#666666', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'InactiveLeftGrad2',    { fg = '#555555', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'InactiveLeftGrad3',    { fg = '#444444', bg = 'NONE' })

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

local function blockleft_inactive(text)
  return table.concat({
    "%#InactiveLeftGrad3#█",
    "%#InactiveLeftGrad2#█",
    "%#InactiveLeftGrad1#█",
    "%#InactiveLeftHighlight# " .. text .. " ",
    "%#InactiveLeftGrad1#█",
    "%#InactiveLeftGrad2#█",
    "%#InactiveLeftGrad3#█",
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

function _G.custom_statusline(winid)
  winid = winid or 0  -- fallback to current window
  local bufnr = vim.api.nvim_win_get_buf(winid)

  -- Mode (active vs inactive)
  local mode
  if winid == vim.api.nvim_get_current_win() then
    mode = blockleft(get_mode())
  else
    mode = blockleft_inactive("INACTIVE")
  end

  -- Filename (always shown)
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  if filename == "" then filename = "[No Name]" end

  -- Position
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local line = cursor[1]
  local col = cursor[2]
  local total_lines = vim.api.nvim_buf_line_count(bufnr)
  local position = string.format("%d/%d, %d", line, total_lines, col)

  -- Filetype
  local ft = vim.bo[bufnr].filetype
  if ft == "" then ft = "no ft" end

  -- Git branch (from file’s directory)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local branch = ""
  if filepath ~= "" then
    local filedir = vim.fn.fnamemodify(filepath, ":h")
    local cmd = string.format("git -C '%s' rev-parse --abbrev-ref HEAD 2>/dev/null", filedir)
    local handle = io.popen(cmd)
    if handle then
      branch = handle:read("*l") or ""
      handle:close()
    end
  end

  -- Left side blocks
  local left = table.concat({
    mode,
    "  ",
    blockleft(filename),
    "  ",
    blockleft(position),
  })

  -- Right side blocks
  local right = blockright(ft)
  if branch ~= "" then
    right = right .. "  " .. blockright(branch)
  end

  return left .. " %= " .. right
end


vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function(args)
    local winid = args.win or vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_option(
      winid,
      "statusline",
      string.format("%%!v:lua.custom_statusline(%d)", winid)
    )
  end,
})

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
  local step = math.floor(0.7 * win_height)

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

---- Print all mappings (<Leader>m)

-- List all normal mode mappings in a scratch buffer
vim.keymap.set('n', '<Leader>m', function()
    local buf = vim.api.nvim_create_buf(false, true)  -- scratch buffer
    local lines = {}

    -- Get all normal mode mappings
    local maps = vim.api.nvim_get_keymap('n')
    for _, m in ipairs(maps) do
        table.insert(lines, string.format("%-10s -> %s", m.lhs, m.desc or m.rhs or "<no rhs>"))
    end

    -- Set lines and options
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)

    -- Open in a new floating window
    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.6)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })
end, { noremap = true, silent = true })

---- navbuddy plugin
local navbuddy = require("nvim-navbuddy")

-- require("lspconfig").clangd.setup {
--     on_attach = function(client, bufnr)
--         navbuddy.attach(client, bufnr)
--     end
-- }

local navbuddy = require("nvim-navbuddy")
local actions = require("nvim-navbuddy.actions")

navbuddy.setup {
    window = {
        border = "single",  -- "rounded", "double", "solid", "none"
                            -- or an array with eight chars building up the border in a clockwise fashion
                            -- starting with the top-left corner. eg: { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }.
        size = "60%",       -- Or table format example: { height = "40%", width = "100%"}
        position = "50%",   -- Or table format example: { row = "100%", col = "0%"}
        scrolloff = nil,    -- scrolloff value within navbuddy window
        sections = {
            left = {
                size = "20%",
                border = nil, -- You can set border style for each section individually as well.
            },
            mid = {
                size = "40%",
                border = nil,
            },
            right = {
                -- No size option for right most section. It fills to
                -- remaining area.
                border = nil,
                preview = "leaf",  -- Right section can show previews too.
                                   -- Options: "leaf", "always" or "never"
            }
        },
    },
    node_markers = {
        enabled = true,
        icons = {
            leaf = "  ",
            leaf_selected = " → ",
            branch = " ",
        },
    },
    icons = {
        File          = "[🗎]",
        Module        = "[M] ",
        Namespace     = "[N] ",
        Package       = "[P] ",
        Class         = "[C] ",
        Method        = "[m] ",
        Property      = "[p] ",
        Field         = "[f] ",
        Constructor   = "[c] ",
        Enum          = "[E] ",
        Interface     = "[i] ",
        Function      = "[f] ",
        Variable      = "[v] ",
        Constant      = "[c] ",
        String        = "[s] ",
        Number        = "[n] ",
        Boolean       = "[b] ",
        Array         = "[a] ",
        Object        = "[o] ",
        Key           = "[k] ",
        Null          = "[n] ",
        EnumMember    = "[e] ",
        Struct        = "[s] ",
        Event         = "[e] ",
        Operator      = "[>] ",
        TypeParameter = "[t] ",
    },
    use_default_mappings = true,            -- If set to false, only mappings set
                                            -- by user are set. Else default
                                            -- mappings are used for keys
                                            -- that are not set by user
    mappings = {
        ["<esc>"] = actions.close(),        -- Close and cursor to original location
        ["q"] = actions.close(),

        ["j"] = actions.next_sibling(),     -- down
        ["k"] = actions.previous_sibling(), -- up

        ["h"] = actions.parent(),           -- Move to left panel
        ["l"] = actions.children(),         -- Move to right panel
        ["0"] = actions.root(),             -- Move to first panel

        ["v"] = actions.visual_name(),      -- Visual selection of name
        ["V"] = actions.visual_scope(),     -- Visual selection of scope

        ["y"] = actions.yank_name(),        -- Yank the name to system clipboard "+
        ["Y"] = actions.yank_scope(),       -- Yank the scope to system clipboard "+

        ["i"] = actions.insert_name(),      -- Insert at start of name
        ["I"] = actions.insert_scope(),     -- Insert at start of scope

        ["a"] = actions.append_name(),      -- Insert at end of name
        ["A"] = actions.append_scope(),     -- Insert at end of scope

        ["r"] = actions.rename(),           -- Rename currently focused symbol

        ["d"] = actions.delete(),           -- Delete scope

        ["f"] = actions.fold_create(),      -- Create fold of current scope
        ["F"] = actions.fold_delete(),      -- Delete fold of current scope

        ["c"] = actions.comment(),          -- Comment out current scope

        ["<enter>"] = actions.select(),     -- Goto selected symbol
        ["o"] = actions.select(),

        ["J"] = actions.move_down(),        -- Move focused node down
        ["K"] = actions.move_up(),          -- Move focused node up

        ["s"] = actions.toggle_preview(),   -- Show preview of current node

        ["<C-v>"] = actions.vsplit(),       -- Open selected node in a vertical split
        ["<C-s>"] = actions.hsplit(),       -- Open selected node in a horizontal split

        ["t"] = actions.telescope({         -- Fuzzy finder at current level.
            layout_config = {               -- All options that can be
                height = 0.60,              -- passed to telescope.nvim's
                width = 0.60,               -- default can be passed here.
                prompt_position = "top",
                preview_width = 0.50
            },
            layout_strategy = "horizontal"
        }),

        ["g?"] = actions.help(),            -- Open mappings help window
    },
    lsp = {
        auto_attach = false,   -- If set to true, you don't need to manually use attach function
        preference = nil,      -- list of lsp server names in order of preference
    },
    source_buffer = {
        follow_node = true,    -- Keep the current node in focus on the source buffer
        highlight = true,      -- Highlight the currently focused node
        reorient = "smart",    -- "smart", "top", "mid" or "none"
        scrolloff = nil        -- scrolloff value when navbuddy is open
    },
	custom_hl_group = nil,     -- "Visual" or any other hl group to use instead of inverted colors
}


require'treesitter-context'.setup{
    enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

