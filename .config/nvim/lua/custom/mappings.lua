---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.telescope = {
  n = {
    ["<leader>fe"] = { "<cmd> Telescope diagnostics <CR>", "Diagnostics" },
  },
}

return M
