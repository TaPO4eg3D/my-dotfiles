return {
  {
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = { 
      -- Extension of LSP capabitlites
      {
        "folke/neodev.nvim",
        opts = { 
          experimental = {
            pathStrict = true,
          },
        },
      },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        pyright = {}
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
