-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

vim.cmd "autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o"
vim.cmd "set nrformats+=alpha"

vim.g.loaded_python3_provider = nil
vim.opt.splitkeep = "screen"
vim.g.python3_host_prog = "~/.asdf/installs/python/3.10.12/bin/python"

vim.cmd [[
  nnoremap n nzz
  nnoremap N Nzz
  nnoremap * *zz
  nnoremap # #zz
  nnoremap g* g*zz
  nnoremap g# g#zz
  command WQ wq
  command Wq wq
  command W w
  command Q q
  autocmd FileType typescript let b:dispatch = 'npm run build'
  set noswapfile
  " autocmd CursorHold * lua vim.diagnostic.open_float()
  au BufReadPost *.njk set filetype=html
]]
