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
  "folke/which-key.nvim",
  "neovim/nvim-lspconfig",
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "shaunsingh/nord.nvim",
  -- "github/copilot.vim",
  "tpope/vim-fugitive",
  "nvim-treesitter/nvim-treesitter",
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
})


-- options
vim.opt.clipboard:append { 'unnamedplus' }
vim.o.number = true
vim.cmd [[autocmd FileType * set formatoptions-=ro]] -- otherwise it gets overwritten by some random ftplugin. absolutely bullshit

vim.cmd[[colorscheme nord]]

-- lsp
local lspconfig = require "lspconfig"

local servers = { "html", "cssls", "tsserver", "clangd", "pylsp", "eslint", "tailwindcss", "terraform_lsp" }

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
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>e', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

