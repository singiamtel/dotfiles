-- plugins

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
	  "folke/which-key.nvim",
	  event = "VeryLazy",
	  init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	  end,
	  opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	  }
	},
	"neovim/nvim-lspconfig",
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	"shaunsingh/nord.nvim",
	"github/copilot.vim",
	"tpope/vim-fugitive",
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup {
				highlight = {
					enable = true,
				},
			}
		end,
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup {
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
			}
		end,
	},
	"Almo7aya/openingh.nvim",
	"tpope/vim-surround"
})


-- options
vim.opt.clipboard:append { 'unnamedplus' }
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.smartcase = true
vim.opt.undodir = os.getenv( "HOME" ) .. '/.local/share/nvim/undo' -- -_-
vim.opt.undofile = true

vim.o.number = true
vim.cmd [[autocmd FileType * set formatoptions-=ro]] -- otherwise it gets overwritten by some random ftplugin. absolutely bullshit

vim.cmd[[colorscheme nord]]

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- lsp
local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "tsserver", "clangd", "pyright", "eslint", "tailwindcss", "terraform_lsp" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

lspconfig.terraformls.setup {
	on_attach = function()
		require("treesitter-terraform-doc").setup()
	end,
	capabilities = capabilities,
}


-- keymaps
vim.g.mapleader = ' '
local noop = function() end -- FIXME: This cannot be right
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>e', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>bd', "<CMD>bd<CR>", {desc = "Delete buffer"})
vim.keymap.set('n', '<F1>', noop)
vim.keymap.set('n', '<F2>', "<CMD>lua vim.lsp.buf.rename()<CR>", {})

vim.cmd [[
	nnoremap <silent> <down> <c-e>
	nnoremap <silent> <up> <c-y>
	]]

