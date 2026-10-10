-- Note: modern nvim-treesitter (main) removed `nvim-treesitter.configs`;
-- setup is done via the `nvim-treesitter` module directly.
require('nvim-treesitter').setup {
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

local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end


---- Telescope mappings
pcall(require('telescope').load_extension, 'fzf')
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


local navbuddy = require("nvim-navbuddy")

-- require("lspconfig").clangd.setup {
--     on_attach = function(client, bufnr)
--         navbuddy.attach(client, bufnr)
--     end
-- }

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
