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
}
