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
  use {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.8',
  requires = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup{
      defaults = {
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        file_ignore_patterns = {},
        vimgrep_arguments = {
          'rg',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
        },
      },
    }
  end
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
 
  use {
    'mfussenegger/nvim-lint',
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            python = { "flake8" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end
  }
  use {
    'stevearc/conform.nvim',
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black" },
        },
      })
    end
  }
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

  -- LaTex stuff
  use {
  'lervag/vimtex',
  ft = { 'tex' },

  config = function()
    vim.g.vimtex_view_method = 'zathura'

    vim.g.vimtex_compiler_method = 'latexmk'

    vim.g.vimtex_compiler_latexmk = {
      options = {
        '-pdf',
        '-shell-escape',
        '-interaction=nonstopmode',
        '-synctex=1',
        '-file-line-error',
      },
    }
  end
}

  if packer_bootstrap then
    require('packer').sync()
  end
end)
