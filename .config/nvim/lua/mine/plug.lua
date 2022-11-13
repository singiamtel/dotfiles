vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

	use {'andymass/vim-matchup', event = 'VimEnter'}

	-- LSP
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"lukas-reineke/lsp-format.nvim"
	}

	use 'ggandor/leap.nvim'

	use 'wellle/context.vim'

	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-cmdline'
	use 'onsails/lspkind.nvim'
	use 'hrsh7th/nvim-cmp'
	use 'SirVer/ultisnips'
	use 'quangnguyen30192/cmp-nvim-ultisnips'
	use 'honza/vim-snippets'
	use 'github/copilot.vim'
	use "MunifTanjim/nui.nvim"
	use "rcarriga/nvim-notify"
	-- use("folke/noice.nvim")
	use('jose-elias-alvarez/null-ls.nvim')
	use('MunifTanjim/prettier.nvim')

	use {'ziontee113/neo-minimap'}

	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
	}


	use 'tpope/vim-obsession'
	use 'dhruvasagar/vim-prosession'

	use 'machakann/vim-highlightedyank'

	use 'tpope/vim-repeat'
	use 'tpope/vim-surround'
	use 'tpope/vim-fugitive'
	use 'mhinz/vim-signify'
	use 'tpope/vim-commentary'
	use 'tpope/vim-markdown'
	use 'ThePrimeagen/harpoon'
	use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

	use 'jiangmiao/auto-pairs'

	use {
		'filipdutescu/renamer.nvim',
		branch = 'master',
		requires = { {'nvim-lua/plenary.nvim'} },
		config = function()
			require('renamer').setup()
		end
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

	use {'arcticicestudio/nord-vim', as = 'nord'}
end)
