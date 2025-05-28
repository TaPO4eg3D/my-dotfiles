local M = {}


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

-- Window navigation (Defined by vim-tmux-navigator)
map("n", "<A-h>", "<C-w>h")
map("n", "<A-j>", "<C-w>j")
map("n", "<A-l>", "<C-w>l")
map("n", "<A-k>", "<C-w>k")

-- Russian keyboard
-- vim.o.keymap = "russian-jcukenwin"

-- map("n", "<C-i>", function()
--   local v = (vim.o.iminsert + 1) % 2
--
--   vim.o.iminsert = v
--   vim.o.imsearch = v
-- end)
-- map("i", "<C-i>", '<C-^>')

-- Resize window using <ctrl-direction>
-- map("n", "<C-k>", "<cmd>resize +2<cr>")
-- map("n", "<C-j>", "<cmd>resize -2<cr>")
-- map("n", "<C-h>", "<cmd>vertical resize -2<cr>")
-- map("n", "<C-l>", "<cmd>vertical resize +2<cr>")

-- Cycle buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Tabs
map("n", "<leader>tn", "<cmd>:tabnew<cr>", { desc = "New tab" })
map("n", "<leader>th", "<cmd>:tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>tl", "<cmd>:tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tc", "<cmd>:tabclose<cr>", { desc = "Close the tab" })

map("n", "<leader>cf", function()
  local file_path = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('+', file_path)

  vim.notify("File path copied to clipboard: " .. file_path, vim.log.levels.INFO)
end, {
  desc = "Copy the full file path to clipboard"
})

-- Documenting available keymappings and groups
local wk = require('which-key')

wk.register({
  ["<leader>"] = {
    f = {
      name = "operations with files",
    },
    d = {
      name = "debugger control"
    },
    g = {
      name = "git operations"
    },
    t = {
      name = "tabs operations"
    }
  }
})

-- Rust Specific Keybindings
function M.setup_rust_keybindings()
  local wk = require('which-key')
  local bufnr = vim.api.nvim_get_current_buf()

  wk.register({
    ["<leader>"] = {
      r = {
        h = {
          name = "Rust Tools"
        }
      }
    }
  })

  vim.keymap.set(
      "n", "<leader>ra",
      function()
        vim.cmd.RustLsp('codeAction')
      end,
      {
        silent = true,
        buffer = bufnr,
        desc = "Code actions"
      }
  )

  vim.keymap.set(
      "n", "<leader>rhr",
      function()
        vim.cmd.RustLsp('runnables')
      end,
      {
        silent = true,
        buffer = bufnr,
        desc = "Show Rust Runnables and run selected"
      }
  )

  vim.keymap.set(
      "n", "<leader>rhp",
      function()
        vim.cmd.RustLsp('rebuildProcMacros')
      end,
      {
        silent = true,
        buffer = bufnr,
        desc = "Rebuild proc macros"
      }
  )

  vim.keymap.set(
      "n", "<leader>rhe",
      function()
        vim.cmd.RustLsp('expandMacro')
      end,
      {
        silent = true,
        buffer = bufnr,
        desc = "Recursively expand macro"
      }
  )

  vim.keymap.set(
    "n", "<leader>dd",
    function()
      vim.cmd.RustLsp('debuggables')
    end,
    {
      silent = true,
      buffer = bufnr,
      desc = "Get debuggables of rust-analyzer"
    }
  )
end

return M
