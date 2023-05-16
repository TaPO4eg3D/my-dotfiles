local M = {}

--- Notify wrapper to autosupply plugin information
--- @param msg string
--- @param level integer|nil (vim.log.levels)
function M.notify(msg, level)
  vim.notify(msg, level, {
    title = "Django DB Instance Switcher",
  })
end

return M
