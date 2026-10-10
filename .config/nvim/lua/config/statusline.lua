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

-- diagnostics for status line
local function diagnostics_summary(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local diags = vim.diagnostic.get(bufnr)

  local errors, warns = 0, 0
  for _, d in ipairs(diags) do
    if d.severity == vim.diagnostic.severity.ERROR then
      errors = errors + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      warns = warns + 1
    end
  end

  if errors == 0 and warns == 0 then
    return ""
  end

  local parts = {}
  if errors > 0 then
    table.insert(parts, "%#StatusError#Ⓔ: " .. errors .. "%#Normal#")
  end
  if warns > 0 then
    table.insert(parts, "%#StatusWarn#Ⓦ: " .. warns .. "%#Normal#")
  end

  return table.concat(parts, "  ")
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
  local diag = diagnostics_summary(bufnr)
  local right = ""

  if diag ~= "" then
    right = diag .. "  "
  end

  right = right .. blockright(ft)

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
