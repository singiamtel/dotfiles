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
		},
	},
	{ "kevinhwang91/nvim-bqf", ft = "qf" },
	"neovim/nvim-lspconfig",
	"junegunn/fzf",
	"nvim-treesitter/nvim-treesitter-context",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		-- or                              , branch = '0.1.x',
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			-- "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		lazy = false,
		branch = "regexp", -- This is the regexp branch, use this for the new version
		config = function()
			require("venv-selector").setup({
				lazy = false,
				settings = {
					options = {
						debug = true,
						enable_cached_venvs = true,
						cached_venv_automatic_activation = true,
					},
				},
			})
		end,
	},
	"shaunsingh/nord.nvim",
	"github/copilot.vim",
	"rcarriga/nvim-notify",
	"tpope/vim-fugitive",
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disable_mouse = false,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				ensure_installed = {
					"vimdoc",
					"luadoc",
					"vim",
					"lua",
					"markdown",
				},
			})
		end,
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				suppressed_dirs = { "~/", "~/Downloads", "/" },
			})
		end,
	},
	{
		"m00qek/baleia.nvim",
		version = "*",
		config = function()
			vim.g.baleia = require("baleia").setup({})

			-- Command to colorize the current buffer
			vim.api.nvim_create_user_command("Colorize", function()
				vim.g.baleia.once(vim.api.nvim_get_current_buf())
			end, { bang = true })

			-- Command to show logs
			vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
		end,
	},
	"Almo7aya/openingh.nvim",
	"tpope/vim-surround",
	"metakirby5/codi.vim",
})

vim.notify = require("notify")

require("keymaps").setup()

-- options
vim.opt.clipboard:append({ "unnamedplus" })
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.smartcase = true
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo" -- -_-
vim.opt.undofile = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.number = true
vim.o.relativenumber = true
vim.g.nord_contrast = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]]) -- otherwise it gets overwritten by some random ftplugin. absolutely bullshit

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.tabstop = 8
-- vim.opt.softtabstop = 0
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = {
	tab = "!·",
	trail = "·",
}

vim.cmd([[autocmd FileType python setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab]])

vim.cmd([[colorscheme nord]])

vim.o.guifont = "FiraCode Nerd Font Propo:h12"

-- lsp
local lspconfig = require("lspconfig")

local servers =
	{ "html", "cssls", "ts_ls", "clangd", "eslint", "rust_analyzer", "tailwindcss", "terraform_lsp", "bashls" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

vim.lsp.enable({ "pyrefly" })

lspconfig.terraformls.setup({
	on_attach = function()
		require("treesitter-terraform-doc").setup()
	end,
	capabilities = capabilities,
})
