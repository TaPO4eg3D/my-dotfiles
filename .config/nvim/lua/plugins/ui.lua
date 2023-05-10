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
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts) 
      vim.notify = require("notify")
      vim.notify.setup(opts)
    end
  },

  -- Transparent BG
  -- {
  --   "xiyaowong/transparent.nvim",
  --   config = function(_, opts)
  --     require("transparent").setup(opts)

  --     vim.cmd[[TransparentEnable]]
  --   end
  -- },

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
    opts = {
      input = {
        insert_only = false,
      },
    },
    init = function()
      vim.ui.select = function()
        require("lazy").load({
          plugins = { "dressing.nvim" },
        })
      end

      vim.ui.input = function()
        require("lazy").load({
          plugins = { "dressing.nvim" },
        })
      end
    end
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

}
