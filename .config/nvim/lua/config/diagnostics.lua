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
vim.api.nvim_set_hl(0, "StatusError", {
  fg = "#ff5555",
  bold = true,
})
vim.api.nvim_set_hl(0, "StatusWarn", {
  fg = "#ffb86c",
  bold = true,
})


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


local function open_diag_list()
  local bufnr = vim.api.nvim_get_current_buf()
  local diags = vim.diagnostic.get(bufnr)

  -- Build items list
  local items = {}
  for _, d in ipairs(diags) do
    if d.severity == vim.diagnostic.severity.ERROR
       or d.severity == vim.diagnostic.severity.WARN then

      local icon = d.severity == vim.diagnostic.severity.ERROR
        and "Ⓔ"
        or "Ⓦ"

      local msg = d.message:gsub("\n.*", "")
      if #msg > 20 then
        msg = msg:sub(1, 20)
      end

      table.insert(items, {
        text = string.format("%s: %d: %s", icon, d.lnum + 1, msg),
        lnum = d.lnum + 1,
      })
    end
  end

  if #items == 0 then
    return
  end

  -- Create scratch buffer
  diag_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(diag_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(diag_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(diag_buf, "swapfile", false)

  -- Populate buffer (must be modifiable while writing)
  vim.api.nvim_buf_set_option(diag_buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(
    diag_buf,
    0,
    -1,
    false,
    vim.tbl_map(function(i) return i.text end, items)
  )
  vim.api.nvim_buf_set_option(diag_buf, "modifiable", false)

  -- Floating window size
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.min(#items + 2, math.floor(vim.o.lines * 0.6))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  diag_win = vim.api.nvim_open_win(diag_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    style = "minimal",
  })

  vim.api.nvim_win_set_option(diag_win, "cursorline", true)

  -- Close helper
  local function close()
    if diag_win and vim.api.nvim_win_is_valid(diag_win) then
      vim.api.nvim_win_close(diag_win, true)
    end
    diag_win, diag_buf = nil, nil
  end

  -- Keymaps inside the floating window
  vim.keymap.set("n", "j", "j", { buffer = diag_buf })
  vim.keymap.set("n", "k", "k", { buffer = diag_buf })

  vim.keymap.set("n", "l", function()
    local idx = vim.api.nvim_win_get_cursor(diag_win)[1]
    close()
    vim.api.nvim_win_set_cursor(0, { items[idx].lnum, 0 })
  end, { buffer = diag_buf })

  vim.keymap.set("n", "<CR>", function()
    local idx = vim.api.nvim_win_get_cursor(diag_win)[1]
    close()
    vim.api.nvim_win_set_cursor(0, { items[idx].lnum, 0 })
  end, { buffer = diag_buf })

  vim.keymap.set("n", "<Esc>", close, { buffer = diag_buf })
  vim.keymap.set("n", "q", close, { buffer = diag_buf })
end

vim.keymap.set("n", "<leader>we", open_diag_list, { silent = true })
vim.keymap.set("n", "<leader>ew", open_diag_list, { silent = true })
