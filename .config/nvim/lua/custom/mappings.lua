---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.telescope = {
  n = {
    ["<leader>e"] = { "<cmd> Telescope diagnostics <CR>", "Diagnostics" },
    -- ["<leader>f"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>g"] = { "<cmd> Telescope live_grep <CR>", "Grep" },
    ["<F3>"] = { "<cmd> Telescope live_grep <CR>", "Grep" },
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    }
  },
}

return M
