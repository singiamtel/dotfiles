require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "tsserver", "jdtls", "pyright", "csharp_ls", "omnisharp", "tailwindcss", "cssls"},
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' }
	}, {
	})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = 'buffer' },
	})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = { "bash", "c", "cpp", "css", "dockerfile", "html", "java", "javascript", "json", "lua", "python", "regex", "rust", "scss", "tsx", "typescript", "yaml" },
	sync_install = false,
	auto_install = true,

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		disable = function(lang, buf)
			local max_filesize = 150 * 1024 -- 150 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		additional_vim_regex_highlighting = false,
	},
}

local builtin = require'telescope.builtin'

local on_attach_fn = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', builtin.lsp_definitions, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
end

local lspconfig = require('lspconfig')

lspconfig['pyright'].setup{
	on_attach = on_attach,
	flags = lsp_flags,
}

lspconfig['tsserver'].setup{
	on_attach = function(client, bufnr)
		on_attach_fn(client, bufnr)
		client.server_capabilities.document_formatting = false
	end,
	flags = lsp_flags,
}
lspconfig['jdtls'].setup{
	on_attach = on_attach_fn,
	flags = lsp_flags,
}

lspconfig['cssls'].setup{
	on_attach = on_attach_fn,
	flags = lsp_flags,
}

lspconfig.gopls.setup { on_attach = on_attach_fn }

lspconfig["csharp_ls"].setup(
{
	capabilities = capabilities,
	on_attach = on_attach_fn,
	flags = lsp_flags,
	cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	init_options = {
		configurationsPath = vim.fn.stdpath("config") .. "/omnisharp",
	},
	filetypes = { "cs", "vb" },
	root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
}
)

-- If extension is jsx/tsx then use typescript-language-server
if vim.bo.filetype == "javascriptreact" or vim.bo.filetype == "typescriptreact" then
	lspconfig["tailwindcss"].setup(
	{
		capabilities = capabilities,
		on_attach = on_attach_fn,
		flags = lsp_flags,
	}
	)
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

if vim.fn.filereadable(".prettierrc.json") == 1 then
	-- local null_ls = require("null-ls")

	-- null_ls.setup({
	-- 	on_attach = function(client, bufnr)
	-- 		client.server_capabilites.documentFormattingProvider = true
	-- 		-- if client.server_capabilities.documentFormattingProvider then
	-- 		-- format on save
	-- 		-- vim.cmd("autocmd InsertLeave <buffer> lua vim.lsp.buf.format()")

	-- 	end,
	-- })
	-- vim.lsp.null_ls.setup.timeout_ms = 5000
	local prettier = require("prettier")

	prettier.setup({
		bin = 'prettier', -- or `'prettierd'` (v0.22+)
		filetypes = {
			"css",
			"graphql",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"less",
			"markdown",
			"scss",
			"typescript",
			"typescriptreact",
			"yaml",
		},
	})
	vim.keymap.set('n', '<leader>l', vim.lsp.buf.format, opts)
else

	lspconfig.eslint.setup(
	{
		capabilities = capabilities,
		flags = {debounce_text_changes = 500},
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = true
			vim.keymap.set('n', '<leader>l', '<cmd>EslintFixAll<cr>')
			on_attach_fn(client, bufnr)
		end
	}
	)

	-- vim.api.nvim_create_autocmd('InsertLeave', {
		-- 	pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
		-- 	command = 'silent! EslintFixAll',
		-- 	group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
		-- })
end
