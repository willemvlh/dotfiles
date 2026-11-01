require("config.lazy")
require('mason').setup()
require('mason-lspconfig').setup()
require('nvim-tree').setup({
  filters = {
    git_ignored = false
  },
  renderer = {
    highlight_git = true,
  }
})

-- Transparent variant of tokyonight's lightline palette: drop every background.
-- Segments drawn as dark text on a coloured block (e.g. the mode) instead use
-- that colour as the text colour, so they stay readable.
do
  local colors = require("tokyonight.colors").setup()
  local palette = vim.deepcopy(require("lightline.colorscheme.tokyonight"))
  for _, mode in pairs(palette) do
    for _, side in pairs(mode) do
      for i, seg in ipairs(side) do
        local fg = seg[1] == colors.black and seg[2] or seg[1]
        -- Full {guifg, guibg, ctermfg, ctermbg, attr} entry, so lightline uses it verbatim
        side[i] = { fg, "NONE", "NONE", "NONE", seg[1] == colors.black and "bold" or "" }
      end
    end
  end
  vim.g["lightline#colorscheme#tokyonight_transparent#palette"] = palette
end

vim.g.lightline = {
  colorscheme = "tokyonight_transparent",
  active = {
    left = {
      { "mode",     "paste" },
      { "readonly", "relativepath", "modified" }
    },
    right = {
      { "lineinfo" }, { "percent" }, { "filetype", "fileencoding" }
    }
  },
  inactive = {
    left = { { "relativepath", "modified" } },
  }
}
require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebars = "transparent", -- nvim-tree, help, terminals, etc.
    floats = "dark",          -- keep popups (hover, completion) opaque for readability
  },
  on_highlights = function(hl)
    -- Base of the buffer bar; bufferline groups without a bg inherit this
    hl.TabLineFill = { bg = "NONE" }
    hl.TabLine = { fg = hl.TabLine.fg, bg = "NONE" }
    hl.StatusLine = { fg = hl.StatusLine.fg, bg = "NONE" }
    hl.StatusLineNC = { fg = hl.StatusLineNC.fg, bg = "NONE" }
    -- Unused variables/imports; tokyonight's default (#414868) is too dark without its bg
    hl.DiagnosticUnnecessary = { fg = "#6c7590" }
  end,
})
vim.cmd("colorscheme tokyonight-night")
vim.api.nvim_set_hl(0, "LineNr", { fg = "#a8d2ff" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6090cc" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#4070bb" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e1e1e" })
vim.api.nvim_set_hl(0, "Comment", { fg = "#879999", italic = true })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#333333" })
vim.api.nvim_set_hl(0, "NvimTreeGitFileIgnoredHL", { fg = "#aaaaaa", italic = true })
vim.api.nvim_set_hl(0, "NvimTreeGitFileDirtyHL", { fg = "#ddbb44" })
vim.api.nvim_set_hl(0, "", { bg = "#1e1e1e" })
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.wo.number = true
-- Statusline hidden by default (toggle with <leader>s). When shown, it's one global
-- statusline (laststatus=3) so nvim-tree doesn't get its own. showmode is on only
-- while the statusline is hidden, since lightline displays the mode itself.
vim.o.laststatus = 0
vim.o.showmode = true
vim.opt.fillchars:append({ eob = " " }) -- hide ~ on lines past end of buffer
vim.o.winborder = "rounded"
vim.o.autowriteall = true -- This makes sure modified buffers are saved when running an external command
-- Enable filetype detection, plugins, and indentation
vim.cmd('filetype plugin indent on')

-- Show existing tab with 4 spaces width
vim.o.tabstop = 2

-- When indenting with '>', use 4 spaces width
vim.o.shiftwidth = 2

-- On pressing tab, insert 4 spaces
vim.o.expandtab = true
vim.o.relativenumber = true
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-g>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    },
    {
      { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', {
  capabilities = capabilities
})

vim.lsp.enable('gopls')

vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = { 'clangd', '--compile-commands-dir=%/..' }
})

-- jdtls is configured via ftplugin/java.lua (required for debug support)
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = true
})

vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>fm', function()
      vim.lsp.buf.format { async = false }
    end, opts)
  end,
})


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- Only open if it's a directory
    if data.file == "" then
      require('nvim-tree.api').tree.open()
    end
  end
})

vim.api.nvim_set_option("clipboard", "unnamedplus")

vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<F12>', ':bufdo bwipeout<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-i>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true })
vim.keymap.set('t', '<C-[>', [[<C-\><C-n>]])
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').man_pages)
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>l', function()
  vim.o.relativenumber = not vim.o.relativenumber
end)
vim.keymap.set('n', '<leader>s', function()
  local hidden = vim.o.laststatus ~= 0
  vim.o.laststatus = hidden and 0 or 3
  vim.o.showmode = hidden
end, { desc = "Toggle statusline" })
vim.keymap.set('n', ',', '^', { noremap = true })
vim.keymap.set('n', '<leader>c', ':bdelete | blast<CR>', { noremap = true })
vim.keymap.set('n', '<leader>>', function()
  if (vim.bo.filtype == "NvimTree") then
    vim.cmd(":vertical resize 80%")
  end
end)
vim.keymap.set('n', '<leader><', function()
  if (vim.bo.filtype == "NvimTree") then
    vim.cmd(":vertical resize 80%")
  end
end)
vim.o.ignorecase = true
vim.o.smartcase = true


require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    numbers = "buffer_id",
    tab_size = 11,
    show_buffer_icons = false
  },
  -- Transparent: take every default bufferline highlight and drop its background
  highlights = function(defaults)
    local hls = {}
    for name, hl in pairs(defaults.highlights) do
      hls[name] = vim.tbl_extend("force", hl, { bg = "NONE" })
      if name:match("separator") then
        hls[name].fg = "#333333" -- separators are normally drawn in the bg colour; keep them visible
      end
    end
    return hls
  end,
}

require("toggleterm").setup {
  size = 15,
}

for i = 1, 4 do
  vim.keymap.set('n', '<leader>' .. i, '<cmd>' .. i .. 'ToggleTerm<CR>', { noremap = true, silent = true })
end



--Copilot
--Use <C-J> to accept copilot suggestions
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
vim.g.copilot_proxy_strict_ssl = false

vim.cmd("runtime macros/matchit.vim")

--Debugging

local mason_dap = require("mason-nvim-dap")
local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

dap_virtual_text.setup()
ui.setup()

mason_dap.setup({
  handlers = {
    function(config)
      require("mason-nvim-dap").default_setup(config)
    end
  }
})

-- Auto open/close dapui when debug sessions start/end
dap.listeners.after.event_initialized["dapui_config"] = function() ui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() ui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() ui.close() end

-- DAP keymaps
vim.keymap.set('n', '<F5>', dap.continue, { desc = "Debug: Continue" })
vim.keymap.set('n', '<F3>', dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<F2>', dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<F4>', dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>B', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = "Debug: Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Debug: Open REPL" })
vim.keymap.set('n', '<leader>du', ui.toggle, { desc = "Debug: Toggle UI" })
vim.keymap.set('n', '<leader>dq', dap.terminate, { desc = "Debug: Terminate" })
