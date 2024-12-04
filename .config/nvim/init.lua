vim.g.mapleader = " "  -- Set the leader key to space
vim.g.maplocalleader = " "  -- Set the local leader key to space

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

-- Hybrid absolute and relative line numbering
vim.opt.number = true
vim.opt.relativenumber = true


-- Ensure packer is installed
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- LSP support
  use 'hrsh7th/nvim-cmp' -- Completion framework
  use 'hrsh7th/cmp-nvim-lsp' -- LSP completions
  use 'L3MON4D3/LuaSnip' -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-lua/plenary.nvim' -- Dependency for many plugins
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'preservim/nerdtree' -- File explorer
  use 'dense-analysis/ale' -- Asynchronous linting
  use 'tpope/vim-fugitive' -- Git integration
  use 'hrsh7th/cmp-buffer'          -- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path'            -- Path completion
  use 'hrsh7th/cmp-cmdline'         -- Command-line completion
  use 'saadparwaiz1/cmp_luasnip'    -- Snippet completion
  use 'L3MON4D3/LuaSnip'            -- Snippet engine
  use 'rafamadriz/friendly-snippets' -- Predefined snippets for common languages
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
  end
})
end)

-------------------------------------------------------------------------
-- For C/C++ development
-------------------------------------------------------------------------
local lspconfig = require('lspconfig')
-- Configure clangd for C/C++
lspconfig.clangd.setup {
  cmd = { "clangd" },
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
}

-- C/C++ parser
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- C/C++ autocompletion
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

-- C/C++ real-time linting
vim.g.ale_fixers = { ['c'] = { 'clang-format' }, ['cpp'] = { 'clang-format' } }
vim.g.ale_linters = { ['c'] = { 'clang' }, ['cpp'] = { 'clang' } }
vim.g.ale_fix_on_save = 1

-- C/C++ consistent formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- C/C++ debugging
require('packer').use {
  "mfussenegger/nvim-dap",
  requires = {
    "rcarriga/nvim-dap-ui", -- Debug UI
    "mfussenegger/nvim-dap-python", -- Python DAP support
  },
}

-- Example debugger config for C++
local dap = require('dap')
dap.adapters.cppdbg = {
  type = 'executable',
  command = '/path/to/OpenDebugAD7', -- Change to your debugger's path
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
      {
        text = '-enable-pretty-printing',
        description =  'Enable GDB pretty printing',
        ignoreFailures = false
      },
    },
  },
}

-- Disable clang-format as a fixer
vim.g.ale_fixers = {
    ['c'] = {}, -- No fixers for C
    ['cpp'] = {}, -- No fixers for C++
}
vim.g.ale_cpp_clangformat_executable = '' -- Ensures ALE won't invoke clang-format
vim.g.ale_fix_on_save = 0 -- Disable auto-fix on save


local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For luasnip users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

require('telescope').setup{}
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })

local luasnip = require('luasnip')

-- Load snippets from friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- Key mappings to expand snippets
vim.keymap.set({ "i", "s" }, "<C-e>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<S-C-e>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })
-- Setup autopairs with nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end


npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}


------------------------------------------------------------------------
-- Mappings
------------------------------------------------------------------------
vim.api.nvim_set_keymap('i', 'C-(', '()<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '{{', '{}<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '[[', '[]<Left>', { noremap = true, silent = true })
print("Config loaded!")  -- Add this at the top of your init.lua

[leo@maverick tmp]$ vim /tmp/erwkerjew.cpp
[leo@maverick tmp]$ vim ~/.config/nvim/init.lua 
[leo@maverick tmp]$ cat !$
cat ~/.config/nvim/init.lua
vim.g.mapleader = " "  -- Set the leader key to space
vim.g.maplocalleader = " "  -- Set the local leader key to space

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

-- Hybrid absolute and relative line numbering
vim.opt.number = true
vim.opt.relativenumber = true


-- Ensure packer is installed
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
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
  use 'nvim-lualine/lualine.nvim'    -- Statusline
  use 'preservim/nerdtree'           -- File explorer
  use 'dense-analysis/ale'           -- Asynchronous linting
  use 'tpope/vim-fugitive'           -- Git integration
  use 'hrsh7th/cmp-buffer'           -- Buffer source for nvim-cmp
  use 'hrsh7th/cmp-path'             -- Path completion
  use 'hrsh7th/cmp-cmdline'          -- Command-line completion
  use 'rafamadriz/friendly-snippets' -- Predefined snippets for common languages
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
  end
})
end)

-------------------------------------------------------------------------
-- For C/C++ development
-------------------------------------------------------------------------
local lspconfig = require('lspconfig')
-- Configure clangd for C/C++
lspconfig.clangd.setup {
  cmd = { "clangd" },
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
}

-- C/C++ parser
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- C/C++ autocompletion
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

-- C/C++ real-time linting
vim.g.ale_fixers = { ['c'] = { 'clang-format' }, ['cpp'] = { 'clang-format' } }
vim.g.ale_linters = { ['c'] = { 'clang' }, ['cpp'] = { 'clang' } }
vim.g.ale_fix_on_save = 1

-- C/C++ consistent formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- C/C++ debugging
require('packer').use {
  "mfussenegger/nvim-dap",
  requires = {
    "rcarriga/nvim-dap-ui", -- Debug UI
    "mfussenegger/nvim-dap-python", -- Python DAP support
  },
}

-- Example debugger config for C++
local dap = require('dap')
dap.adapters.cppdbg = {
  type = 'executable',
  command = '/path/to/OpenDebugAD7', -- Change to your debugger's path
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
      {
        text = '-enable-pretty-printing',
        description =  'Enable GDB pretty printing',
        ignoreFailures = false
      },
    },
  },
}

-- Disable clang-format as a fixer
vim.g.ale_fixers = {
    ['c'] = {}, -- No fixers for C
    ['cpp'] = {}, -- No fixers for C++
}
vim.g.ale_cpp_clangformat_executable = '' -- Ensures ALE won't invoke clang-format
vim.g.ale_fix_on_save = 0 -- Disable auto-fix on save


local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For luasnip users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

require('telescope').setup{}
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })

local luasnip = require('luasnip')

-- Load snippets from friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- Key mappings to expand snippets
vim.keymap.set({ "i", "s" }, "<C-e>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<S-C-e>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })
-- Setup autopairs with nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end


npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt", "spectre_panel" },
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}
