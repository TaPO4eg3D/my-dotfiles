return {
  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    version = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      winopts = {
        fullscreen = true,
      },
    },
    keys = {
      {
        "<leader>fr",
        "<cmd>FzfLua resume<cr>",
        desc = "Resume Last Search",
      },
      {
        "<leader>ff",
        "<cmd>FzfLua git_files<cr>",
        desc = "Find files",
      },
      {
        "<leader>fF",
        "<cmd>FzfLua files<cr>",
        desc = "Find Files (Git)",
      },
      {
        "<leader>fi",
        "<cmd>FzfLua live_grep<cr>",
        desc = "Live Grep",
      },
      {
        "<leader>o",
        "<cmd>FzfLua buffers<cr>",
        desc = "Inspect opened Buffers",
      },
      {
        "<leader>fh",
        "<cmd>FzfLua help_tags<cr>",
        desc = "Search NeoVim help tags",
      },
    },
  },

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker",
        opts = {
          autoselect_one = true,
          include_current = false,
          filter_rules = {
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', "neo-tree-popup", "notify" },

              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', "quickfix" },
            },
          },
          highlights = {
            statusline = {
              unfocused = {
                bg = "#f051c6",
              },
            }
          },
        },
      }
    },
    keys = {
      {
        "<leader>nn",
        "<cmd>Neotree<CR>",
        desc = "Explorer NeoTree",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1

      -- Open NeoTree if NeoVim was opened with a directory as an argument
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["W"] = "open_with_window_picker",
          ["O"] = {
            function(state)
              local node = state.tree:get_node()
              local filepath = node.path
              local osType = os.getenv("OS")

              local command

              if osType == "Windows_NT" then
                command = "start " .. filepath
              elseif osType == "Darwin" then
                command = "open " .. filepath
              else
                local handle = io.popen("which handlr")
                assert(handle)

                local result = handle:read("*a")
                handle:close()

                if not string.find(result, "not found") then
                  command = "handlr open " .. filepath
                else
                  command = "xdg-open " .. filepath
                end
              end

              vim.notify("Openning a file..")
              os.execute(command)
            end
          }
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
  },
}
