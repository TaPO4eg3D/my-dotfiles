local utils = require("utils")

return {
  -- Colorschema
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
  },

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      fps = 144,
      background_colour = "#000000",
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      vim.notify = require("notify")
      vim.notify.setup(opts)

      -- TODO: Move to utils
      local highlights = vim.fn.getcompletion("", "highlight")
      local patters = {
        "Notify%w*Title",
        "Notify%w*Body",
        "Notify%w*Border",
      }

      local extra_groups = {}

      for _, highlight in ipairs(highlights) do
        for _, pattern in ipairs(patters) do
          local match = string.match(highlight, pattern)

          if match ~= nil then
            extra_groups[#extra_groups + 1] = highlight
            break
          end
        end
      end

      vim.g.transparent_groups = vim.list_extend(
        vim.g.transparent_groups or {}, extra_groups
      )
    end
  },

  -- Transparent BG
  {
    "xiyaowong/transparent.nvim",
    opts = {
      extra_groups = {
        "NormalFloat",
        "NotifyBackground",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
      },
    },
    config = function(_, opts)
      require("transparent").setup(opts)

      vim.cmd [[TransparentEnable]]
    end
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Improved vim.ui functions
  {
    "stevearc/dressing.nvim",
    lazy = true,
    dependencies = {
      "fzf-lua",
    },
    opts = {
      input = {
        insert_only = false,
      },
      select = {
        fzf_lua = {
          winopts = {
            fullscreen = false,
          },
        },
      },
    },
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({
          plugins = { "dressing.nvim" },
        })

        return vim.ui.select(...)
      end

      vim.ui.input = function(...)
        require("lazy").load({
          plugins = { "dressing.nvim" },
        })

        return vim.ui.input(...)
      end
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 500

      require("which-key").setup(opts)
    end,
  },

  -- LSP breadcrumbs
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

      require("utils").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
      }
    end,
  },
}
