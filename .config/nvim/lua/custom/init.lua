-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })


vim.cmd("autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o")

vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog =  '~/.asdf/installs/python/3.10.12/bin/python'
