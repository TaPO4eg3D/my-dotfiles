return {
  -- auto completion
  {
    "ms-jpq/coq_nvim",
    version = false,
    build = ":COQdeps",
    event = "InsertEnter",
    config = function(plugin, opts)
      vim.g.coq_settings = {
        clients = {
          lsp = {
            always_on_top = {},
            resolve_timeout = 0.5
          }
        }
      }

      vim.cmd[[:COQnow]]
    end
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

  -- Environment picker
  {
    "tapo4eg3d/instance-switcher",
    dev = true,
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
    "TimUntersberger/neogit",
    cmd = "Neogit",
    keys = {
      {
        "<leader>M",
        "<cmd>Neogit<CR>",
        desc = "Run NeoGit"
      },
    },
  }
}
