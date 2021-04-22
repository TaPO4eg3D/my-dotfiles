local lspconfig = require'lspconfig'

local custom_attach = function(client)
  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end
end

lspconfig.elmls.setup({
  on_attach = custom_attach
})
