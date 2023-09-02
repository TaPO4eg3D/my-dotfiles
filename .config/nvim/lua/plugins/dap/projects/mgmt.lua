local dap = require("dap")

local M = {}

function M.setup()
  local pathMappings = {
      {
        localRoot = "${workspaceFolder}",
        remoteRoot = "/app"
      },
      {
        localRoot = "${workspaceFolder}/.venv/lib/python3.11/site-packages",
        remoteRoot = "/usr/local/lib/python3.10/dist-packages"
      }
  }

  table.insert(dap.configurations.python, {
    type = 'python',
    request = 'attach',
    name = 'Attach to Running MGMT',
    connect = {
      host = 'localhost',
      port = 3000,
    },
    pathMappings = pathMappings,
  })

  table.insert(dap.configurations.python, {
    type = 'python',
    request = 'attach',
    name = 'Attach to MGMT Console',
    connect = {
      host = 'localhost',
      port = 3800,
    },
    pathMappings = pathMappings,
  })
end

return M
