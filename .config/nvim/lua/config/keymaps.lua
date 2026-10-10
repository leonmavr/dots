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
-- LSP: list clangd [f]ixes
vim.keymap.set("n", "<C-f>", vim.lsp.buf.code_action, {
    desc = "LSP Code Actions",
    silent = true,
})
-- nagivate across long wrapped lines
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- quickly escape
vim.api.nvim_set_keymap('i', 'kkk', '<Esc>', { noremap = true })

-- <Leader>w = save
vim.keymap.set('n', '<Leader>w', ':w<CR>', { noremap = true })

-- <Leader>q = quit without saving
vim.keymap.set('n', '<Leader>q', ':q!<CR>', { noremap = true })

-- Normal/visual: move current line down/up and reindent
vim.keymap.set('n', '<C-J>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.keymap.set('n', '<C-K>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.keymap.set('v', '<C-J>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', '<C-K>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

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

-- VimTeX keymaps
vim.keymap.set('n', '<leader>ll', '<cmd>VimtexCompile<CR>', { silent = true })
vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStop<CR>', { silent = true })
vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<CR>', { silent = true })
vim.keymap.set('n', '<leader>le', '<cmd>VimtexErrors<CR>', { silent = true })
vim.keymap.set('n', '<leader>lc', '<cmd>VimtexClean<CR>', { silent = true })
vim.keymap.set('n', '<leader>lt', '<cmd>VimtexTocOpen<CR>', { silent = true })

