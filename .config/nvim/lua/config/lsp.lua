--------------------------------------------------------------------------
-- Capabilities for nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function configure_lsp(server, config)
  if vim.lsp.config and vim.lsp.enable then
    vim.lsp.config(server, config)
    vim.lsp.enable(server)
    return
  end

  require("lspconfig")[server].setup(config)
end

local function set_lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
end

local function enable_inlay_hints(bufnr)
  if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  elseif vim.lsp.buf.inlay_hint then
    vim.lsp.buf.inlay_hint(bufnr, true)
  end
end

-- Shared on_attach for Python (Pyright)
local function pyright_on_attach(client, bufnr)
    set_lsp_keymaps(bufnr)

    -- Attach Navbuddy
    require("nvim-navbuddy").attach(client, bufnr) end
-- Pyright setup with Navbuddy
configure_lsp("pyright", {
    capabilities = capabilities,
    on_attach = pyright_on_attach,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",   -- or "strict"
                autoImportCompletions = true,
            },
        },
    },
      })



-- require('lint').linters_by_ft = {
--   python = { 'flake8' },  -- or 'pylint'
-- }


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
    local guard = base_guard .. '_' .. ext:upper() .. '_'
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

-- shared on_attach for clangd
-- in case plugins like navbuddy need to use it
local function clangd_on_attach(client, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }

    set_lsp_keymaps(bufnr)

    -- Clangd specific
    vim.keymap.set('n', '<leader>sh', ':ClangdSwitchSourceHeader<CR>', opts)
    vim.keymap.set('n', '<leader>ih', ':ClangdToggleInlayHints<CR>', opts)

    -- Enable inlay hints initially
    enable_inlay_hints(bufnr)

    -- Attach Navbuddy
    require("nvim-navbuddy").attach(client, bufnr)
end

-- clangd setup with combined config
configure_lsp("clangd", {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--limit-results=20"},
    init_options = {
        fallbackFlags = { "-Wall", "-Wextra", "-std=c++17" },
    },
    on_attach = clangd_on_attach,
})

vim.g.ale_linters = { ['c'] = { 'clang' }, ['cpp'] = { 'clang' } }
-- vim.g.ale_fixers = { ['c'] = {}, ['cpp'] = {} } -- Disabled clang-format
vim.g.ale_cpp_clangformat_executable = ''
vim.g.ale_fix_on_save = 0
