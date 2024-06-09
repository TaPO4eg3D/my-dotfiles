return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      ensure_installed = {
        "c",
        "lua",
        "bash",
        "python",
        "html",
        "javascript",
        "typescript",
        "rust",
        "yaml",
        "markdown",
      },
    },
    config = function(_, opts)
      local py_utils = require("utils.python")

      vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
        group = vim.api.nvim_create_augroup("MyPythonUtils", { clear = true }),
        pattern = "*py",
        desc = "Set Python Utils keybindings",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>rc", "", {
            callback = py_utils.copy_python_path,
            noremap = true,
            desc = "Copy Python Module Path"
          })
        end
      })

      require("nvim-treesitter.configs").setup(opts)
    end
  },

  -- Playground allows to inspect the tree built by the Treesitter
  {
    'nvim-treesitter/playground',
    cmd = 'TSPlaygroundToggle',
  },
}
