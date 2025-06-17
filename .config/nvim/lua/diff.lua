local M = {}

-- Store the first selection
local first_selection = nil

function M.store_selection()
    -- Must be called from visual mode
    if vim.fn.mode() ~= 'v' and vim.fn.mode() ~= 'V' and vim.fn.mode() ~= '\22' then
        print("Error: Must be called from visual mode")
        return
    end
    
    -- Get the selected text using vim.fn.getregion()
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    
    -- Get the actual selected text
    local selection_lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode() })
    
    if #selection_lines == 0 then
        print("Error: No text selected")
        return
    end
    
    first_selection = table.concat(selection_lines, '\n')
    print("First selection stored (" .. #selection_lines .. " lines): " .. string.sub(first_selection, 1, 50) .. (string.len(first_selection) > 50 and "..." or ""))
end

function M.diff_with_stored()
    if not first_selection then
        print("No first selection stored. Use :DifftStore first.")
        return
    end
    
    -- Must be called from visual mode  
    if vim.fn.mode() ~= 'v' and vim.fn.mode() ~= 'V' and vim.fn.mode() ~= '\22' then
        print("Error: Must be called from visual mode")
        return
    end
    
    -- Get current visual selection
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    
    -- Get the actual selected text
    local selection_lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode() })
    
    if #selection_lines == 0 then
        print("Error: No text selected")
        return
    end
    
    local second_selection = table.concat(selection_lines, '\n')
    print("Comparing selections...")
    print("First: " .. string.sub(first_selection, 1, 30) .. "...")
    print("Second: " .. string.sub(second_selection, 1, 30) .. "...")
    
    -- Create temporary files in a reliable temp directory
    local temp_dir = os.getenv("TMPDIR") or os.getenv("TMP") or "/tmp"
    -- Remove trailing slash if present
    temp_dir = temp_dir:gsub("/$", "")
    
    local timestamp = os.time()
    local random = math.random(1000, 9999)
    local file1 = temp_dir .. "/nvim_difft_" .. timestamp .. "_" .. random .. "_1.txt"
    local file2 = temp_dir .. "/nvim_difft_" .. timestamp .. "_" .. random .. "_2.txt"
    
    -- Write selections to temp files
    local f1 = io.open(file1, 'w')
    if not f1 then
        print("Error: Could not create temporary file " .. file1)
        return
    end
    f1:write(first_selection)
    f1:close()
    
    local f2 = io.open(file2, 'w')
    if not f2 then
        print("Error: Could not create temporary file " .. file2)
        os.remove(file1)  -- Clean up first file
        return
    end
    f2:write(second_selection)
    f2:close()
    
    -- Verify files exist
    local f1_check = io.open(file1, 'r')
    local f2_check = io.open(file2, 'r')
    if not f1_check or not f2_check then
        print("Error: Temporary files were not created properly")
        if f1_check then f1_check:close() end
        if f2_check then f2_check:close() end
        os.remove(file1)
        os.remove(file2)
        return
    end
    f1_check:close()
    f2_check:close()
    
    -- Create new terminal buffer with diff output
    vim.cmd('new')
    local buf = vim.api.nvim_get_current_buf()
    
    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_name(buf, 'Difftastic Output')
    
    -- Set up keymap to close with 'q'
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>q<CR>', { 
        noremap = true, 
        silent = true,
        desc = 'Close diff buffer'
    })
    
    -- Run difftastic in terminal buffer
    local cmd = string.format('difft --color=always %s %s; echo ""; echo "Press q to close"', vim.fn.shellescape(file1), vim.fn.shellescape(file2))
    vim.fn.termopen(cmd, {
        on_exit = function()
            -- Clean up temp files after command completes
            vim.schedule(function()
                os.remove(file1)
                os.remove(file2)
                if vim.api.nvim_buf_is_valid(buf) then
                    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
                    -- Re-add the keymap after terminal exits (in case it got overridden)
                    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>q<CR>', { 
                        noremap = true, 
                        silent = true 
                    })
                end
            end)
        end
    })
    
    -- Enter normal mode in terminal
    vim.cmd('stopinsert')
    
    -- Clear stored selection
    first_selection = nil
    print("Diff complete. First selection cleared.")
end

function M.quick_diff()
    -- Store current selection and wait for next selection
    M.store_selection()
    
    print("Now select the second text and press <leader>dd or run :DifftCompare")
end

function M.quick_diff_complete()
    -- This should be called after selecting the second text
    M.diff_with_stored()
end

-- Create commands
vim.api.nvim_create_user_command('DifftStore', function()
    M.store_selection()
end, { range = true })

vim.api.nvim_create_user_command('DifftCompare', function()
    M.diff_with_stored()
end, { range = true })

vim.api.nvim_create_user_command('DifftQuick', function()
    M.quick_diff()
end, { range = true })

vim.api.nvim_create_user_command('DifftComplete', function()
    M.quick_diff_complete()
end, { range = true })

-- Optional: Create keymaps
-- vim.keymap.set('v', '<leader>ds', M.store_selection, { desc = 'Store selection for diff' })
-- vim.keymap.set('v', '<leader>dc', M.diff_with_stored, { desc = 'Compare with stored selection' })
-- vim.keymap.set('v', '<leader>dq', M.quick_diff, { desc = 'Quick diff - store first selection' })
-- vim.keymap.set('v', '<leader>dd', M.quick_diff_complete, { desc = 'Quick diff - compare with stored' })

return M
