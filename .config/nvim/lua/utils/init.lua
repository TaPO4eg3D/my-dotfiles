local M = {}

local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", {})

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_group,
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      on_attach(client, buffer)
    end,
  })
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy", -- Event provided by Lazy.nvim
    callback = function()
      fn()
    end,
  })
end

return M
