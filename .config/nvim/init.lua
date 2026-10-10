-------------------------------------------------------------------------------
-- Requirements
-------------------------------------------------------------------------------

-- # LSP
-- sudo npm install -g pyright

-- # Python tools
-- pip install black flake8 debugpy

-- # C/C++ support
-- clangd

-- # for Telescope (optional)
-- fd-find (Ubuntu/Debian) / fd (Arch)
-- rg

-- Optionally, to render and live-view LaTex:
-- zathura, latexmk

-------------------------------------------------------------------------------
-- Neovim 0.11+ compatibility shims
-------------------------------------------------------------------------------
-- vim.tbl_islist was removed in Neovim 0.11, but the original
-- wbthomason/packer.nvim still calls it (packer.lua:284), which crashes
-- startup. Re-add it so Packer (and any other plugin that relies on it) works.
if not vim.tbl_islist then
  vim.tbl_islist = function(t)
    if type(t) ~= "table" then
      return false
    end
    local count = 0
    for _ in pairs(t) do
      count = count + 1
      if t[count] == nil then
        return false
      end
    end
    return true
  end
end


require("config.options")
require("config.keymaps")
require("config.plugins")
require("config.lsp")
require("config.diagnostics")
require("config.plugin_config")
require("config.statusline")
