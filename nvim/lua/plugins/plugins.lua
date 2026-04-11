return {
  { "williamboman/mason.nvim", opts = {} },
  "williamboman/mason-lspconfig.nvim",
  'neovim/nvim-lspconfig',
  'nvimtools/none-ls.nvim',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-vsnip',
  'hrsh7th/vim-vsnip',
  'windwp/nvim-autopairs',
  { 'nvim-tree/nvim-tree.lua', lazy = false, priority = 80 },
  "folke/tokyonight.nvim",
  "catppuccin/nvim",
  { "nvim-telescope/telescope.nvim", tag = '0.1.8', requires = { { 'nvim-lua/plenary.nvim' } } },
  "nvim-tree/nvim-web-devicons",
  "tpope/vim-endwise",
  "andymass/vim-matchup",
  "rafamadriz/friendly-snippets",
  'itchyny/lightline.vim',
  { 'akinsho/bufferline.nvim',       version = "*", dependencies = 'nvim-tree/nvim-web-devicons' },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "suketa/nvim-dap-ruby"
    },
    config = function()
      require("dap-ruby").setup()
    end
  },
   {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
    },
  { "nvim-treesitter/nvim-treesitter", branch = 'master',                                                  lazy = false, build = ":TSUpdate" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec"
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rspec")
        }
      })
    end
  },
  { "github/copilot.vim" },
  {'akinsho/toggleterm.nvim', version = "*", config = true},

}
