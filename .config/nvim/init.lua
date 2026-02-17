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
    {
        "folke/which-key.nvim",
        {
            'gelguy/wilder.nvim',
            config = function()
                local wilder = require('wilder')
                wilder.setup({ modes = { ':', '/', '?' } })

                wilder.set_option('pipeline', {
                    wilder.branch(
                        wilder.cmdline_pipeline({
                            fuzzy = 1,
                            set_pcre2_pattern = 1,
                        }),
                        wilder.python_search_pipeline({
                            pattern = 'fuzzy',
                        })
                    ),
                })

            end,
        },
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    "neovim/nvim-lspconfig",
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
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.listchars = {
    tab = "!·",
    trail = "·",
}
-- vim.opt.diffopt:append("horizontal")

vim.cmd([[autocmd FileType python setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab]])

vim.cmd([[colorscheme nord]])

vim.o.guifont = "FiraCode Nerd Font Propo:h12"

local vue_language_server_path = '/path/to/@vue/language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

vim.lsp.enable({ "html", "cssls", "clangd", "rust_analyzer", "tailwindcss", "terraform_lsp", "bashls", "pyright", "gopls", "lua_ls", "biome", "vtsls", "vue_ls" })
-- "eslint", 

-- vim.lsp.enable({ "pyrefly" })

-- lspconfig.terraformls.setup({
--     on_attach = function()
--         require("treesitter-terraform-doc").setup()
--     end,
--     capabilities = capabilities,
-- })
