vim.g.mapleader = " "

local function noop() end -- FIXME: There must be a better way to disable the help popup

local function toggle_quickfix()
    local qf_exists = false
    local qf_focused = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
            if win["winid"] == vim.api.nvim_get_current_win() then
                qf_focused = true
            end
        end
    end

    if qf_exists and not qf_focused then
        vim.cmd("copen") -- Focus the quickfix window
    elseif qf_exists then
        vim.cmd("cclose")
    elseif not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    end
end

local M = {}

local diff = require("diff")

M.setup = function()
    -- Buffer management
    vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer" })
    vim.keymap.set("n", "<leader>bq", "<cmd>q<cr>", { desc = "Quit" })
    vim.keymap.set("n", "<leader><leader>", "<cmd>b#<cr>", { desc = "Switch to last buffer" })
    vim.keymap.set("n", "<c-j>", "<cmd>bn<cr>", { desc = "Next buffer" })
    vim.keymap.set("n", "<c-k>", "<cmd>bp<cr>", { desc = "Previous buffer" })
    vim.keymap.set("n", "<leader>c", "<cmd> silent execute '!cursor . --goto %:' . line('.') . ':' . col('.')<cr>",
        { desc = "Open in Cursor" })


    -- diffs
    vim.keymap.set('v', '<leader>ds', diff.store_selection, { desc = 'Store selection for diff' })
    vim.keymap.set('v', '<leader>dc', diff.diff_with_stored, { desc = 'Compare with stored selection' })
    vim.keymap.set('v', '<leader>dq', diff.quick_diff, { desc = 'Quick diff - store and wait for next selection' })



    -- Editor functions
    vim.keymap.set("n", "<F1>", noop, { desc = "Disable help popup" })
    vim.keymap.set("n", "<leader>dt", "<cmd>:%s/\\s\\+$//e<cr>", { desc = "Delete trailing spaces" })
    vim.keymap.set("n", "<leader>h", "<cmd>set hls!<cr>", { desc = "Toggle search highlighting" })
    vim.keymap.set("n", "<down>", "<c-e>", { silent = true })
    vim.keymap.set("n", "<up>", "<c-y>", { silent = true })
    vim.keymap.set("n", "n", "nzzzv")
    vim.keymap.set("n", "N", "Nzzzv")

    -- Git commands
    vim.keymap.set("n", "<leader>gb", "<cmd>G blame -w<cr>", { desc = "Git blame" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "Git diff split" })

    -- Quickfix navigation
    vim.keymap.set("n", "<leader>[", "<cmd>cprevious<cr>", { desc = "Previous quickfix item" })
    vim.keymap.set("n", "<leader>]", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
    vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Toggle quickfix window" })

    -- LSP keymaps
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, { desc = "LSP: Rename symbol" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
    vim.keymap.set("n", "<s-m>", vim.diagnostic.open_float, { desc = "LSP: Show diagnostics" })
    vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next, { desc = "LSP: Jump to next diagnostic" })
    vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev, { desc = "LSP: Jump to previous diagnostic" })
    vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP: Show info" })
    vim.keymap.set("n", "<leader>lk", "<cmd>LspStop<cr>", { desc = "LSP: Stop" })
    vim.keymap.set("n", "<leader>ls", "<cmd>LspStart<cr>", { desc = "LSP: Start" })
    vim.keymap.set("n", "<leader>fo", vim.lsp.buf.format, { desc = "LSP: Format document" })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'vim.lsp.buf.hover()' })

    vim.keymap.set("n", "<leader>v", "<cmd>VenvSelect<cr>", { desc = "Select Python virtual environment" })


    -- Telescope keymaps
    local telescope = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ea", telescope.diagnostics, { desc = "Telescope: Diagnostics" })
    vim.keymap.set("n", "<leader>ff", function()
        telescope.find_files({
            hidden = true,
            file_ignore_patterns = { "^.git/" },
        })
    end, { desc = "Telescope: Find files" })
    vim.keymap.set("n", "<leader>fw", telescope.live_grep, { desc = "Telescope: Live grep" })
    vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Telescope: Buffers" })
    vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope: Help tags" })
    vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "Telescope: Keymaps" })
end

return M
