local function h_select(n)
  require('harpoon'):list():select(n)
end

return {
  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    version = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- For my custom UI
      "MunifTanjim/nui.nvim",
    },
    opts = {
      fzf_colors = {
        true,
        bg = '-1',
        gutter = '-1',
      },
      winopts = {
        backdrop = 0,
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
        "<leader>foi",
        function()
          local fzf = require('fzf-lua')

          local Input = require("nui.input")
          local event = require("nui.utils.autocmd").event

          local input = Input({
            position = "50%",
            size = {
              width = 50,
            },
            border = {
              style = "single",
              text = {
                top = "Ripgrep options",
                top_align = "center",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
          }, {
            prompt = "> ",
            default_value = "",
            on_close = function()
              print("Search canceled")
            end,
            on_submit = function(value)
              fzf.live_grep({
                rg_opts = value
              })
            end,
          })

          -- mount/open the component
          input:mount()

          -- unmount component when cursor leaves buffer
          input:on(event.BufLeave, function()
            input:unmount()
          end)
        end,
        desc = "Ripgrep with custom options to RG"
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
    version = "3.15",
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

  -- TMUX Integration
  -- {
  --   "christoomey/vim-tmux-navigator",
  --   cmd = {
  --     "TmuxNavigateLeft",
  --     "TmuxNavigateDown",
  --     "TmuxNavigateUp",
  --     "TmuxNavigateRight",
  --     "TmuxNavigatePrevious",
  --   },
  --   keys = {
  --     { "<A-h>",  "<cmd>TmuxNavigateLeft<cr>" },
  --     { "<A-j>",  "<cmd>TmuxNavigateDown<cr>" },
  --     { "<A-k>",  "<cmd>TmuxNavigateUp<cr>" },
  --     { "<A-l>",  "<cmd>TmuxNavigateRight<cr>" },
  --     { "<A-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
  --   },
  --   config = function()
  --     vim.g.tmux_navigator_no_mappings = 1
  --   end
  -- },

  -- Time tracking
  {
    "ActivityWatch/aw-watcher-vim",
    cmd = {
      'AWStart',
      'AWStatus',
    },
  },

  -- Diagnostics plugin
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        '<leader>a',
        function()
          require('harpoon'):list():add()

          local current_list = require("harpoon"):list():display()

          local msg = "The current list:\n\n"
          for _, item in ipairs(current_list) do
              msg = msg .. "- " .. item .. "\n"
          end

          vim.notify(msg, vim.log.levels.INFO, {
            title = "File added!"
          })

        end,
        desc = "Add file to harpoon",
      },
      {
        '<C-y>',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = "Show list of files in harpoon",
      },
      {
        '<C-h>',
        function()
          h_select(4)
        end,
        desc = "Harpoon -> 4",
      },
      {
        '<C-j>',
        function()
          h_select(1)
        end,
        desc = "Harpoon -> 1",
      },
      {
        '<C-k>',
        function()
          h_select(2)
        end,
        desc = "Harpoon -> 2",
      },
      {
        '<C-l>',
        function()
          h_select(3)
        end,
        desc = "Harpoon -> 3",
      },
      {
        '<C-S-J>',
        function()
          require('harpoon'):list():next()
        end,
        desc = "Harpoon -> Next",
      },
      {
        '<C-S-K>',
        function()
          require('harpoon'):list():prev()
        end,
        desc = "Harpoon -> Prev",
      },
    }
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "openai",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o",  -- your desired model (or use gpt-4o, etc.)
        timeout = 30000,   -- Timeout in milliseconds, increase this for reasoning models
        temperature = 0,
        max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
        --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      },
      web_search_engine = {
        provider = "tavily", -- tavily, serpapi, searchapi, google or kagi
      }
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Below are optional dependencies
      "ibhagwan/fzf-lua",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
}
