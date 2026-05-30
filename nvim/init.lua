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
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.rubyfmt,
  },
})
vim.g.lightline = {
  colorscheme = "tokyonight",
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
vim.api.nvim_set_hl(0, '@function.ruby', { bold = true })
vim.api.nvim_set_hl(0, '@lsp.typemod.class.declaration.ruby', { bold = true })
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.wo.number = true
vim.o.showmode = false
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

vim.lsp.config('clangd', {
  capabilities = capabilities,
  cmd = { 'clangd', '--compile-commands-dir=%/..' }
})

vim.lsp.enable('ruby_lsp')
vim.lsp.enable('jdtls')

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
vim.keymap.set('n', '<leader>few', function()
  require('telescope.builtin').grep_string({ glob_pattern = "!**/spec/**" })
end)
vim.keymap.set('n', '<leader>fe', function()
  require('telescope.builtin').live_grep({ glob_pattern = "!**/spec/**" })
end)
vim.keymap.set('n', '<leader>to', ':Neotest output-panel<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ts', ':Neotest summary<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tn', 'require("neotest").run.run()<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tf', 'require("neotest").run.run(vim.fn.expand("%"))<CR>', { noremap = true })
vim.keymap.set('n', '<leader>l', function()
  vim.o.relativenumber = not vim.o.relativenumber
end)
vim.keymap.set('n', ',', '^', { noremap = true })
vim.keymap.set('n', '<leader>c', ':bdelete | blast<CR>', { noremap = true })
vim.o.ignorecase = true
vim.o.smartcase = true


require("bufferline").setup {
  options = {
    diagnostics = "nvim_lsp",
    separator_style = "thin",
    numbers = "buffer_id",
    tab_size = 11,
    show_buffer_icons = false
  }
}

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = function(lang, buf)
      return lang == "ruby"
    end
  }
}

require("toggleterm").setup {
  size = 15,
  open_mapping = [[<F3>]] -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
}

for i = 1, 4 do
  vim.keymap.set('n', '<leader>' .. i, '<cmd>' .. i .. 'ToggleTerm<CR>', { noremap = true, silent = true })
end


vim.api.nvim_create_user_command("Test", function()
  vim.cmd("Neotest output-panel")
  vim.cmd("Neotest summary")
  vim.cmd("Neotest run")
end, {}
)

--Copilot
--Use <C-J> to accept copilot suggestions
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
vim.g.copilot_proxy_strict_ssl = false


vim.cmd("runtime macros/matchit.vim")

local group = vim.api.nvim_create_augroup("RubyStuff", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "ruby",
  callback = function()
    vim.keymap.set('n', '<F2>', ':99TermExec cmd="bundle exec rspec %"<CR>', { noremap = true, silent = true })
  end,
})
