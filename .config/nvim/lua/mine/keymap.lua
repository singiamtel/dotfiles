vim.keymap.set('n', '<SPACE>', '<nop>')
vim.g.mapleader = ' '

vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u')
vim.keymap.set('', '<F1>', '<nop>')
vim.keymap.set('n', 'Q', '<nop>')

-- Center search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', ',', '<Plug>(matchup-%)')

vim.keymap.set('n', 'qq', ':bd<CR>')
vim.keymap.set('', '<C-h>', '<C-w>h')
vim.keymap.set('', '<C-j>', '<C-w>j')
vim.keymap.set('', '<C-k>', '<C-w>k')
vim.keymap.set('', '<C-l>', '<C-w>l')

vim.keymap.set('', '<C-n>', ':NvimTreeToggle<CR>')

vim.keymap.set('n', '<leader>a', '<c-^>')
vim.keymap.set('n', '<leader>gl', ':diffget //2<CR>')
vim.keymap.set('n', '<leader>gr', ':diffget //3<CR>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)
vim.keymap.set('n', '<leader>b', builtin.buffers)

-- Fugitive
-- vim.keymap.set('n', '<leader>gs', ':G<CR>')
-- nnoremap <leader>g :Ag<cr>
vim.keymap.set('', '<F2>', '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
vim.keymap.set('', '<F3>', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>', { noremap = true, silent = true })



-- nnoremap <leader>s :UltiSnipsEdit<cr>