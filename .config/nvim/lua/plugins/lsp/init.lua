local lsp_keymapping = {
  {
    "<leader>re",
    vim.diagnostic.open_float,
    desc = "Line diagnostics",
  },
  {
    "<leader>rd",
    function()
      require("fzf-lua").lsp_definitions({
        jump_to_single_result = true,
        ignore_current_line = true,
      })
    end,
    desc = "Go to definition",
  },
  {
    "<leader>rr",
    "<cmd>FzfLua lsp_references<CR>",
    desc = "Show references",
  },
  {
    "<leader>rR",
    vim.lsp.buf.rename,
    desc = "Rename symbol",
  },
  {
    "<leader>ra",
    "<cmd>FzfLua lsp_code_actions<CR>",
    desc = "Code Actions",
  },
  -- {
  --   "K",
  --   vim.lsp.hover,
  --   desc = "Hover",
  -- },
  {
    "<leader>rK",
    vim.lsp.buf.signature_help,
    desc = "Signature Help",
  },
}

local function set_keymaps(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(lsp_keymapping) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer

      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = { 
      -- Extension of LSP capabitlites
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
              },
              diagnostics = {
                globals = {'vim'},
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        pyright = {},
        volar = {},
      },
    },
    config = function(_, opts)
      local coq = require("coq")
      local utils = require("utils")
      local servers = opts.servers

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        coq.lsp_ensure_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end

      -- TODO: Mason integration

      for server, _ in pairs(servers) do
        setup(server)
      end

      utils.on_attach(set_keymaps)
    end
  },

  -- Formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- TODO: Add more formatters
          nls.builtins.formatting.stylua,
        },
      }
    end,
	},

  -- Rust tooling
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    opts = {},
    dependencies = {
      "plenary.nvim",
      "nvim-lspconfig",
    },
  },

  -- LSP and DAP manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      "<leader>m",
      "<cmd>Mason<CR>",
      desc = "Open Mason",
    }, 
    opts = {
      ensure_installed = {
        "stylua",
        "pyright",
        "typescript-language-server",
      },
    }
  }
}
