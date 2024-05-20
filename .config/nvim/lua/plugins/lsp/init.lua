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
    "<leader>rf",
    vim.lsp.buf.format,
    desc = "Format Buffer",
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
  {
    "<leader>ri",
    function ()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(0))
    end,
    desc = "Toggle inlay hints",
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
          filetypes = { "yaml" }
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

      for _, server in ipairs(installed_servers) do
        if not vim.list_contains(server_keys) then
          table.insert(server_keys, server)
        end
      end

      for _, server in ipairs(server_keys) do
        setup(server)
      end

      utils.on_attach(function(client, buffer)
        set_keymaps(client, buffer)

        -- Enable Inlay Hints when they are supported
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true)
        end
      end)
    end
  },

  -- LSP Server embedden in NeoVim
  {
    "nvimtools/none-ls.nvim",
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
  -- Managing Crates in Rust
  {
    'saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    dependencies = {
      "hrsh7th/nvim-cmp",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local crates = require('crates')
      crates.setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
      })

      local opts = {
        silent = true,
      }

      --- Merge opts with keymap description
      ---@param desc string
      ---@return table
      local function d(desc)
        ---@type table<string, (string | boolean)>
        local result = {
          desc = desc,
        }
        for k, v in pairs(opts) do result[k] = v end

        return result
      end

      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function(args)
          opts.buffer = args.buf

          vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, d("Display version popup"))
          vim.keymap.set("n", "<leader>cf", crates.show_features_popup, d("Display features popup"))
          vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, d("Display dependencies popup"))

          vim.keymap.set("n", "<leader>cu", crates.update_crate, d("Update crate under the cursor"))
          vim.keymap.set("v", "<leader>cu", crates.update_crates, d("Update selected crates"))
          vim.keymap.set("n", "<leader>ca", crates.update_all_crates, d("Update all crates"))
          vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, d("Upgrade crate under the cursor"))
          vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, d("Upgrade selected crates"))
          vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, d("Upgrade all crates"))

          vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, d("Expand inline crate to table"))
          vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, d("Extract crate into a table"))

          vim.keymap.set("n", "<leader>cH", crates.open_homepage, d("Open crate's homepage"))
          vim.keymap.set("n", "<leader>cR", crates.open_repository, d("Open crate's repository"))
          vim.keymap.set("n", "<leader>cD", crates.open_documentation, d("Open crate's documentation"))
          vim.keymap.set("n", "<leader>cC", crates.open_crates_io, d("Open crate.io"))

          require("cmp").setup.buffer({ sources = { { name = "crates" } } })
        end,
      })
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
