vim.keymap.set('n', '<SPACE>', '<nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '

vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { noremap = true, silent = true })
vim.keymap.set('i', '<F1>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('', '<F1>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('n', 'Q', '<nop>', { noremap = true, silent = true })

-- Center search
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true, silent = true })

vim.keymap.set('n', ',', '<Plug>(matchup-%)', { noremap = true, silent = true })

vim.keymap.set('n', 'qq', ':bd<CR>', { noremap = true, silent = true })
vim.keymap.set('', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>a', '<c-^>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gl', ':diffget //2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gr', ':diffget //3<CR>', { noremap = true, silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', builtin.buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>e', builtin.diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>s', '<cmd>set spell!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gf', '<cmd>e <cfile><cr>', { noremap = true, silent = true })

-- Center on mark jump 
vim.keymap.set('n', '\'1', '\'1zzzv')
vim.keymap.set('n', '\'2', '\'2zzzv')
vim.keymap.set('n', '\'3', '\'3zzzv')
vim.keymap.set('n', '\'4', '\'4zzzv')
vim.keymap.set('n', '\'5', '\'5zzzv')
vim.keymap.set('n', '\'6', '\'6zzzv')
vim.keymap.set('n', '\'7', '\'7zzzv')
vim.keymap.set('n', '\'8', '\'8zzzv')
vim.keymap.set('n', '\'9', '\'9zzzv')


-- Fugitive
-- vim.keymap.set('n', '<leader>gs', ':G<CR>')
-- nnoremap <leader>g :Ag<cr>
vim.keymap.set('', '<F1>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set('', '<F2>', '<cmd>lua require("renamer").rename()<cr>', { noremap = true, silent = true })
vim.keymap.set('', '<F3>', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<cr>', { noremap = true, silent = true })

-- nnoremap <leader>s :UltiSnipsEdit<cr>
