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
        "<leader>fF",
        "<cmd>FzfLua git_files<cr>",
        desc = "Find files (Git)",
      },
      {
        "<leader>ff",
        "<cmd>FzfLua files<cr>",
        desc = "Find Files",
      },
      {
        "<leader>fi",
        "<cmd>FzfLua live_grep<cr>",
        desc = "Live Grep",
      },
      {
        "<leader>fs",
        "<cmd>FzfLua lsp_live_workspace_symbols<cr>",
        desc = "Workspace Symbols",
      },
      {
        "<leader>fS",
        "<cmd>FzfLua lsp_document_symbols<cr>",
        desc = "Document Symbols",
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
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   cmd = "Neotree",
  --   version = "3.15",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     {
  --       "s1n7ax/nvim-window-picker",
  --       opts = {
  --         autoselect_one = true,
  --         include_current = false,
  --         filter_rules = {
  --           -- filter using buffer options
  --           bo = {
  --             -- if the file type is one of following, the window will be ignored
  --             filetype = { 'neo-tree', "neo-tree-popup", "notify" },
  --
  --             -- if the buffer type is one of following, the window will be ignored
  --             buftype = { 'terminal', "quickfix" },
  --           },
  --         },
  --         highlights = {
  --           statusline = {
  --             unfocused = {
  --               bg = "#f051c6",
  --             },
  --           }
  --         },
  --       },
  --     }
  --   },
  --   keys = {
  --     {
  --       "<leader>nn",
  --       "<cmd>Neotree<CR>",
  --       desc = "Explorer NeoTree",
  --     },
  --   },
  --   deactivate = function()
  --     vim.cmd([[Neotree close]])
  --   end,
  --   init = function()
  --     vim.g.neo_tree_remove_legacy_commands = 1
  --
  --     -- Open NeoTree if NeoVim was opened with a directory as an argument
  --     if vim.fn.argc() == 1 then
  --       local stat = vim.loop.fs_stat(vim.fn.argv(0))
  --       if stat and stat.type == "directory" then
  --         require("neo-tree")
  --       end
  --     end
  --   end,
  --   opts = {
  --     filesystem = {
  --       bind_to_cwd = false,
  --       follow_current_file = {
  --         enabled = true,
  --       },
  --       use_libuv_file_watcher = true,
  --     },
  --     window = {
  --       mappings = {
  --         ["<space>"] = "none",
  --         ["W"] = "open_with_window_picker",
  --         ["O"] = {
  --           function(state)
  --             local node = state.tree:get_node()
  --             local filepath = node.path
  --             local osType = os.getenv("OS")
  --
  --             local command
  --
  --             if osType == "Windows_NT" then
  --               command = "start " .. filepath
  --             elseif osType == "Darwin" then
  --               command = "open " .. filepath
  --             else
  --               local handle = io.popen("which handlr")
  --               assert(handle)
  --
  --               local result = handle:read("*a")
  --               handle:close()
  --
  --               if not string.find(result, "not found") then
  --                 command = "handlr open " .. filepath
  --               else
  --                 command = "xdg-open " .. filepath
  --               end
  --             end
  --
  --             vim.notify("Openning a file..")
  --             os.execute(command)
  --           end
  --         }
  --       },
  --     },
  --     default_component_configs = {
  --       indent = {
  --         with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
  --         expander_collapsed = "",
  --         expander_expanded = "",
  --         expander_highlight = "NeoTreeExpander",
  --       },
  --     },
  --   },
  -- },

  -- TMUX Integration
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<A-h>",  "<cmd>TmuxNavigateLeft<cr>" },
      { "<A-j>",  "<cmd>TmuxNavigateDown<cr>" },
      { "<A-k>",  "<cmd>TmuxNavigateUp<cr>" },
      { "<A-l>",  "<cmd>TmuxNavigateRight<cr>" },
      { "<A-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end
  },

  -- Folding
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    },
    config = function(opts)
      vim.o.foldcolumn = '1'

      -- Using ufo provider need a large value
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup(opts)
    end
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      delete_to_trash = true,
      watch_for_changes = true,
    },
    keys = {
      {
        "-",
        "<CMD>Oil<CR>",
        desc = "Open parent directory in Oil"
      }
    },
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

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
  -- Multiple Cursors
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
      set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
      -- set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
      -- set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end)

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  }
}
