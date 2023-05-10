return {
  -- auto completion
  {
    "ms-jpq/coq_nvim",
    version = false,
    build = ":COQdeps",
    event = "InsertEnter",
    config = function(plugin, opts)
      vim.g.coq_settings = {
        clients = {
          lsp = {
            always_on_top = {},
            resolve_timeout = 0.5
          }
        }
      }

      vim.cmd[[:COQnow]]
    end
  }
}
