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
    },

    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
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

  -- Git integration
  {
    "tpope/vim-fugitive",
    version = false,
    cmd = "Git",
  },

  -- Nice DiffView to resolve merge conflicts / observe diffs
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
    keys = {
      {
        "<leader>ng",
        "<cmd>:Neogit<CR>",
        desc = "Open NeoGit"
      }
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
  },
  {
    "vuki656/package-info.nvim",
    opts = {
      package_manager = "npm",
    },
    config = function (opts)
      local package_info = require('package-info')
      package_info.setup(opts)

      local keymap_opts = {
      }
      --- Merge keymap_opts with keymap description
      ---@param desc string
      ---@return table
      local function d(desc)
        ---@type table<string, (string | boolean)>
        local result = {
          desc = desc,
        }
        for k, v in pairs(keymap_opts) do result[k] = v end

        return result
      end

      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("PackageJSON", { clear = true }),
        pattern = "package.json",
        callback = function(args)
          keymap_opts.buffer = args.buf

          vim.keymap.set("n", "<leader>cu", package_info.update, d("Update a package on the selected line"))
        end,
      })

    end
  },
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "x" },    "ga", function() require("opencode").prompt("@this") end,                   { desc = "Add to opencode" })
      vim.keymap.set({ "n", "t" }, "<leader>O", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })
      vim.keymap.set("n",        "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "opencode half page up" })
      vim.keymap.set("n",        "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })

      -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
      vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
      vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
    end,
  },
}
