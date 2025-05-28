return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      -- Set of already predefined snippets for buch of langs and framworks
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      --   end,
      --   expr = true, silent = true, mode = "i",
      -- },
      -- { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      -- { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
  -- auto completion
  -- add blink.compat
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = {},
  },
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    version = 'v1.*',
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
    },

    opts = {
      sources = {
        default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
          }
        },
      },
      keymap = {
        preset = 'enter',
      },
      appearance = {
        nerd_font_variant = 'mono'
      },
      completion = {
        trigger = {
          show_on_insert_on_trigger_character = false
        }
      },
    },
    opts_extend = { "sources.default" },
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   version = false, -- last release is way too old
  --   event = "InsertEnter",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-path",
  --     "saadparwaiz1/cmp_luasnip",
  --   },
  --   opts = function()
  --     local cmp = require("cmp")
  --     local defaults = require("cmp.config.default")()
  --
  --     return {
  --       completion = {
  --         completeopt = "menu,menuone,noselect,preview,noinsert",
  --       },
  --       snippet = {
  --         expand = function(args)
  --           require("luasnip").lsp_expand(args.body)
  --         end,
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-j>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-k>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --         ["<S-CR>"] = cmp.mapping.confirm({
  --           behavior = cmp.ConfirmBehavior.Replace,
  --           select = true,
  --         }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "luasnip" },
  --         { name = "path" },
  --         { name = "crates" },
  --       }),
  --       sorting = defaults.sorting,
  --     }
  --   end,
  -- },
  -- Git info integration
  {
    "lewis6991/gitsigns.nvim",
    version = false,
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>gb",
        "<cmd>Gitsigns toggle_current_line_blame<CR>",
        desc = "Toggle live git blame"
      },
      {
        "<leader>gB",
        "<cmd>Gitsigns blame_line<CR>",
        desc = "Show line blame"
      },
      {
        "<leader>gp",
        "<cmd>Gitsigns preview_hunk<CR>",
        desc = "Preview hunk"
      },
      {
        "<leader>gu",
        "<cmd>Gitsigns reset_hunk<CR>",
        desc = "Undo hunk"
      },
      {
        "]c",
        "<cmd>Gitsigns next_hunk<CR>",
        desc = "Next hunk"
      },
      {
        "[c",
        "<cmd>Gitsigns prev_hunk<CR>",
        desc = "Prev hunk"
      },
    },
  },

  -- Environment picker
  {
    "tapo4eg3d/instance-switcher",
    dev = true,
    lazy = true,
    opts = {
      rules = {
        {
          id = "instance-picker",
          file = "$(root)/.envs/.local/.django",
          prompt = "Select Instance: ",
          env_variable = "DB_CONNECTION_STRING",
          values = "/home/tapo4eg3d/reb-keys.json",
          on_select = function(key_name, payload, _)
            local host
            local db_name = string.gsub(key_name, "-write", "")

            if key_name == "local" then
              db_name = "project"
              host = "postgres"
            else
              host = string.format("%s-maint.rebotics.net", db_name)
            end

            return string.format(
              "postgresql://%s:%s@%s/%s",
              payload.username, payload.password, host, db_name
            )
          end
        }
      },
    },
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
    version = false,
    cmd = "Git",
  },

  -- Nice DiffView to resolve merge confilicts / observe diffs
  {
    "sindrets/diffview.nvim",
    lazy = true,
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    }
  },
  -- Search in Git history
  {
    "aaronhallaert/advanced-git-search.nvim",
    keys = {
      {
        "<leader>gf",
        "<cmd>:AdvancedGitSearch<CR>",
        desc = "Search in Git"
      }
    },
    cmd = {
      "AdvancedGitSearch",
    },
    config = function()
      require("advanced_git_search.fzf").setup {
        -- Insert Config here
      }
    end,
    dependencies = {
      "tpope/vim-fugitive",
      "ibhagwan/fzf-lua",
    }
  },
  -- NeoGit just to try it out
  {
    "NeogitOrg/neogit",
    cmd = {
      "Neogit",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      integrations = {
        telescope = nil,
      },
    },
  }
}
