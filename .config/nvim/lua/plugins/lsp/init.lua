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
    "<leader>rD",
    function()
      require("fzf-lua").lsp_declarations({
        jump_to_single_result = true,
        ignore_current_line = true,
      })
    end,
    desc = "Go to declaration",
  },
  {
    "<leader>rt",
    vim.lsp.buf.type_definition,
    desc = "Go to type definition",
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
  {
    "K",
    vim.lsp.buf.hover,
    desc = "Hover",
  },
  {
    "<leader>rK",
    vim.lsp.buf.signature_help,
    desc = "Signature Help",
  },
}

local function set_keymaps(client, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = Keys.resolve(lsp_keymapping)

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer

      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
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
      "hrsh7th/cmp-nvim-lsp",
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
                globals = { 'vim' },
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
        ccls = {},
        pyright = {},
        volar = {},
        docker_compose_language_service = {
          filetypes = {"yaml"}
        }
      },
    },
    config = function(_, opts)
      local cmp = require("cmp_nvim_lsp")
      local utils = require("utils")
      local mason_lsp = require("mason-lspconfig")
      local servers = opts.servers

      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp.default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        require("lspconfig")[server].setup(server_opts)
      end

      local installed_servers = mason_lsp.get_installed_servers()
      local server_keys = {}

      for server, _ in pairs(servers) do
        table.insert(server_keys, server)
      end

      installed_servers = vim.tbl_extend("force", installed_servers, server_keys)

      for _, server in ipairs(installed_servers) do
        setup(server)
      end

      utils.on_attach(function (client, buffer)
        set_keymaps(client, buffer)

        -- Enable Inlay Hints when they are supported
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(buffer, true)
        end
      end)
    end
  },

  -- Formatters
  -- TODO: Delete it? It's archived now
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
    'mrcjkb/rustaceanvim',
    version = '^4',
    ft = { 'rust' },
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
