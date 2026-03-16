-- Install lazy.nvim if not already installed

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- plugins

require("lazy").setup({
    "neovim/nvim-lspconfig",
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    "junegunn/fzf",
    "nvim-treesitter/nvim-treesitter-context",
    {
        "nvim-telescope/telescope.nvim",
        branch = "master",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            -- "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "master", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "main",
        opts = {
            options = {
                debug = false,
                enable_cached_venvs = true,
                cached_venv_automatic_activation = true,
            },
        },
    },
    "shaunsingh/nord.nvim",
    "github/copilot.vim",
    "rcarriga/nvim-notify",
    "tpope/vim-fugitive",
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false, -- disable the default vim regex highlighting
            },
            ensure_installed = {
                "vimdoc",
                "luadoc",
                "vim",
                "lua",
                "markdown",
            },
        },
    },
    {
        "rmagatti/auto-session",
        opts = {
            log_level = "error",
            suppressed_dirs = { "~/", "~/Downloads", "/" }
        },
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
    {
      'stevearc/oil.nvim',
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {
        win_options = {
    signcolumn = "yes:2",
      },
    },
      -- Optional dependencies
      dependencies = { { "nvim-mini/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
    },
    {
      "refractalize/oil-git-status.nvim",

      dependencies = {
        "stevearc/oil.nvim",
      },

      config = true,
    },
})

vim.notify = require("notify")

require("keymaps").setup()

-- OSC 52 clipboard only on remote (SSH) sessions
if os.getenv "SSH_CONNECTION" ~= nill then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

vim.opt.clipboard:append({ "unnamedplus" })
vim.o.ignorecase = true
vim.o.hlsearch = false
vim.o.smartcase = true
vim.o.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo" -- -_-
vim.o.undofile = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.o.number = true
vim.o.relativenumber = true
vim.g.nord_contrast = true
vim.cmd([[autocmd FileType * set formatoptions-=ro]]) -- otherwise it gets overwritten by some random ftplugin. absolutely bullshit

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.list = true
vim.opt.listchars = {
    tab = "!·",
    trail = "·",
}
-- vim.o.diffopt:append("horizontal")

vim.cmd([[autocmd FileType python setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab]])

vim.lsp.enable("pyrefly")

vim.cmd([[colorscheme nord]])

vim.o.guifont = "FiraCode Nerd Font Propo:h12"
