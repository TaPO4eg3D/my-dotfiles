return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local py_utils = require("utils.python")

      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("MyPythonUtils", { clear = true }),
        pattern = "*.py",
        desc = "Set Python Utils keybindings",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<leader>rc", "", {
            callback = py_utils.copy_python_path,
            noremap = true,
            desc = "Copy Python Module Path",
          })
        end,
      })

      local ensure_installed = {
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
        "markdown_inline",
      }

      require("nvim-treesitter").install(ensure_installed)

      -- Build the list of filetypes we actually have parsers for, so the
      -- FileType autocmd below only fires where treesitter can do something.
      local filetypes = {}
      for _, lang in ipairs(require("nvim-treesitter").get_installed()) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
          table.insert(filetypes, ft)
        end
      end

      -- The main branch no longer has highlight/indent "modules"; enable them
      -- ourselves for the installed parsers.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterHook", { clear = true }),
        pattern = filetypes,
        desc = "Enable treesitter highlighting/indent",
        callback = function(args)
          -- highlighting (start() derives the language from the filetype)
          vim.treesitter.start()

          -- experimental treesitter-based indentation
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
