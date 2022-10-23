vim.opt.backspace="indent,eol,start"
vim.opt.clipboard="unnamedplus"
vim.opt.completeopt="menu,menuone,noselect"
vim.opt.conceallevel=2
vim.opt.confirm = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hidden = true
vim.opt.mouse="a"
vim.opt.hlsearch = false
vim.opt.nrformats=alpha,hex,bin
vim.opt.showmode = false
vim.opt.spell = false
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
-- Set path recursive to current folder, might cause lag on big codebases
vim.opt.path=".,**"
-- Multiple flags, :help shortmess // +=? -- 
vim.opt.shortmess="oOtTatI"
vim.opt.spelllang=en_us,es
vim.opt.splitbelow = true
vim.opt.splitright= true
vim.opt.tabstop=4 
vim.opt.shiftwidth=4
vim.opt.termguicolors = true
vim.opt.timeoutlen=300
vim.opt.undodir = vim.fn.expand("~/.config/nvim/undo/")
vim.opt.undofile = true
vim.opt.list = true
vim.opt.lcs='tab:┊ '
vim.o.updatetime = 250
vim.cmd([[ colorscheme nord ]])

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = ''},
		section_separators = { left = '', right = ''},
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = {'mode', '%{ObsessionStatus("&", "!")}' },
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = { 
			{
				'filename', file_status = true, newfile_status = false, path = 1, shorting_target = 40
			},
		},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}
vim.cmd("set spelllang=en_us")
vim.cmd('autocmd FileType javascript let t:command="npm test"')
vim.cmd("autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o")
vim.cmd('autocmd BufNewFile,BufRead *astro set ft=astro')

-- vim.g.AutoPairs = "{'(':')', '[':']', '{':'}'}"
vim.cmd("let g:AutoPairs = {'(':')', '[':']', '{':'}'}")

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
require("nvim-tree").setup({
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
			},
		},
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
		custom = { "^.git$" } 
	},
})
require('telescope').setup{ defaults = { 
	file_ignore_patterns = { "node_modules" },
	layout_config = {
		preview_width = 60,
	},
} 
}
require('leap').set_default_keymaps()
-- vim.notify = require("notify")
