local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys

  -- do not create the keymap if a lazy keys handler exists
  -- and notify about it as an ERROR
  if keys.active[keys.parse({ lhs, mode = mode }).id] then
    local err_msg = "Keymap conflict detected: " .. lhs
    vim.notify_once(err_msg, vim.log.levels.ERROR)
  else
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- Window navigation
map("n", "<A-h>", "<C-w>h")
map("n", "<A-j>", "<C-w>j")
map("n", "<A-l>", "<C-w>l")
map("n", "<A-k>", "<C-w>k")

