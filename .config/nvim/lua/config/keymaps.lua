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

-- Resize window using <ctrl-direction>
map("n", "<C-k>", "<cmd>resize +2<cr>")
map("n", "<C-j>", "<cmd>resize -2<cr>")
map("n", "<C-h>", "<cmd>vertical resize -2<cr>")
map("n", "<C-l>", "<cmd>vertical resize +2<cr>")

-- Cycle buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })
