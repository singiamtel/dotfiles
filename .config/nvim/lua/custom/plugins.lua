local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    -- dependencies = {
    --   -- format & linting
    --   {
    --     "jose-elias-alvarez/null-ls.nvim",
    --     config = function()
    --       require "custom.configs.null-ls"
    --     end,
    --   },
    -- },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  -- {
  --   "stevearc/conform.nvim",
  --   --  for users those who want auto-save conform + lazyloading!
  --   -- event = "BufWritePre"
  --   lazy = false,
  --   config = function()
  --     require "custom.configs.conform"
  --   end,
  -- },
  {
    "mhartington/formatter.nvim",
    config = function()
      local util = require "formatter.util"

      local function eslint_d()
        print "eslint_d"
        return {
          exe = "eslint_d",
          args = {
            "--stdin",
            "--stdin-filename",
            util.escape_path(util.get_current_buffer_file_path()),
            "--fix-to-stdout",
          },
          stdin = true,
          try_node_modules = true,
        }
      end
      local function prettier()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
          stdin = true,
        }
      end
      require("formatter").setup {
        logging = true,
        -- logging_level = "info",
        filetype = {
          json = { prettier },
          html = { prettier },
          css = { prettier },
          javascript = { eslint_d },
          typescript = { eslint_d },
          javascriptreact = { eslint_d },
          typescriptreact = { eslint_d },
          lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua,

            -- You can also define your own configuration
            function()
              -- Supports conditional formatting
              if util.get_current_buffer_file_name() == "special.lua" then
                return nil
              end

              -- Full specification of configurations is down below and in Vim help
              -- files
              return {
                exe = "stylua",
                args = {
                  "--search-parent-directories",
                  "--stdin-filepath",
                  util.escape_path(util.get_current_buffer_file_path()),
                  "--",
                  "-",
                },
                stdin = true,
              }
            end,
          },
        },
      }
    end,
    lazy = false,
  },
  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  { "kevinhwang91/nvim-bqf", lazy = false },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      }
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = overrides.copilot,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end,
        event = "InsertEnter",
      },
    },
    opts = {
      sources = {
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "luasnip", group_index = 2 },
        { name = "buffer", group_index = 2 },
        { name = "nvim_lua", group_index = 2 },
        { name = "path", group_index = 2 },
      },
      experimental = {
        ghost_text = true,
      },
    },
  },
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "Afourcat/treesitter-terraform-doc.nvim",
  },
  {
    "ldelossa/gh.nvim",
    dependencies = { { "ldelossa/litee.nvim" } },
  },
  {
    "almo7aya/openingh.nvim",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    config = function()
      require("treesitter-context").setup {
        max_lines = 4,
        trim_scope = "outer",
      }
    end,
  },
  {
    "stevearc/overseer.nvim",
    lazy = false,
    config = function()
      require("overseer").setup {
        component_aliases = {
          -- Most tasks are initialized with the default components
          default = {
            { "display_duration", detail_level = 2 },
            "on_output_summarize",
            { "on_output_quickfix", open = true },
            "on_exit_set_status",
            "on_complete_notify",
            "on_complete_dispose",
            "on_result_diagnostics",
            "on_result_diagnostics_quickfix",
          },
          -- Tasks from tasks.json use these components
          default_vscode = {
            "default",
            "on_result_diagnostics",
            "on_result_diagnostics_quickfix",
          },
        },
      }
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "rcarriga/nvim-notify",
  },
  {
    "yorickpeterse/nvim-pqf",
    lazy = false,
    config = function()
      require("pqf").setup()
    end,
  },

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
