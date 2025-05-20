return {
  -- Telescope (file finder)
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- Treesitter (syntax highlighting)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },

  -- Color schemes
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'rose-pine/neovim', name = 'rose-pine' },

  -- Treesitter playground
  'nvim-treesitter/playground',

  -- Harpoon (quick navigation)
  'theprimeagen/harpoon',

  -- Undotree
  'mbbill/undotree',

  -- Git integration
  'tpope/vim-fugitive',

  -- None-ls (null-ls replacement)
  'nvimtools/none-ls.nvim',

  -- Commenting
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },

  -- Tags generation
  'ludovicchabant/vim-gutentags',

  -- Indentation guides
  'lukas-reineke/indent-blankline.nvim',

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' }
  },

  -- Buffer line
  'akinsho/nvim-bufferline.lua',

  -- LSP Zero (LSP setup)
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  },

  -- Rainbow delimiters
  'HiPhish/rainbow-delimiters.nvim',

  -- Linting
  'mfussenegger/nvim-lint',

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
}
