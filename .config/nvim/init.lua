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
		dependencies = {
			'nvim-lua/plenary.nvim',

		}
	},
	{
	  "linux-cultist/venv-selector.nvim",
		dependencies = {
		  "neovim/nvim-lspconfig", 
		  "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
		  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
	  lazy = false,
	  branch = "regexp", -- This is the regexp branch, use this for the new version
	  config = function()
		  require("venv-selector").setup {
			  lazy = false,
			  settings = {
				options = {
				  debug = true,
				  enable_cached_venvs = true,
				  cached_venv_automatic_activation = true
				},
			  },
		  }
		end,
		keys = {
		  { "<leader>v", "<cmd>VenvSelect<cr>" },
		},
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
				ensure_installed = {
					"vimdoc",
					"luadoc",
					"vim",
					"lua",
					"markdown"
				}
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
	{
	  "m00qek/baleia.nvim",
	  version = "*",
	  config = function()
		vim.g.baleia = require("baleia").setup({ })

		-- Command to colorize the current buffer
		vim.api.nvim_create_user_command("Colorize", function()
		  vim.g.baleia.once(vim.api.nvim_get_current_buf())
		end, { bang = true })

		-- Command to show logs 
		vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
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

vim.o.guifont = "FiraCode Nerd Font Propo:h12"

-- lsp
local lspconfig = require('lspconfig')

local servers = { "html", "cssls", "tsserver", "clangd", "pyright", "eslint", "rust_analyzer", "tailwindcss", "terraform_lsp" }

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


--- Keymaps
vim.g.mapleader = ' '
local noop = function() end -- FIXME: This cannot be right
vim.keymap.set('n', '<leader>bd', "<CMD>bd<CR>", {desc = "Delete buffer"})
vim.keymap.set('n', '<F1>', noop)
vim.keymap.set('n', '<leader>dt',  "<CMD>:%s/\\s\\+$//e<CR>", {desc= "Delete trailing spaces"})
vim.keymap.set('n', '<leader><leader>',  "<CMD>:b#<CR>", {desc= "Switch to last buffer"})
vim.keymap.set('n', '<leader>gb', "<CMD>G blame<CR>", {})
--- Keymaps - Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>e', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
--- Keymaps - LSP
vim.keymap.set('n', '<F2>', "<CMD>lua vim.lsp.buf.rename()<CR>", {})
vim.keymap.set('n', 'gd', "<CMD>lua vim.lsp.buf.definition()<CR>", {desc= "LSP: Go to definition"})
vim.keymap.set('n', '<leader>li', "<CMD>LspInfo<CR>", {})
vim.keymap.set('n', '<leader>lk', "<CMD>LspStop<CR>", {})
vim.keymap.set('n', '<leader>ls', "<CMD>LspStart<CR>", {})


vim.cmd [[
nnoremap <silent> <down> <c-e>
nnoremap <silent> <up> <c-y>
nmap n nzzzv
nmap N Nzzzv
set list listchars=tab:!·,trail:·
]]
