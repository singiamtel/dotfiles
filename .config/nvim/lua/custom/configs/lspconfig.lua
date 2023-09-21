local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "pyright", "eslint", "tailwindcss", "terraform_lsp" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.terraformls.setup {
  on_attach = function()
    -- This register the user command "OpenDoc" that you are able to bind to any key.
    require("treesitter-terraform-doc").setup()
  end,
  capabilities = capabilities,
}
