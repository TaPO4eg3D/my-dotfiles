local dap = require("dap")
local dapui = require("dapui")

require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
table.insert(dap.configurations.python, {
  type = 'python',
  request = 'attach',
  name = 'Attach to Rebotics',
  connect = {
      host = 'localhost',
      port = 3000,
  },
  pathMappings = {
      {
          localRoot = "${workspaceFolder}",
          remoteRoot = "/app"
      },
      {
          localRoot = "${workspaceFolder}/.venv/lib/python3.9/site-packages",
          remoteRoot = "/usr/local/lib/python3.9/dist-packages"
      }
  },
  -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
})

-- Setup UI
require("dapui").setup()
require("nvim-dap-virtual-text").setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
