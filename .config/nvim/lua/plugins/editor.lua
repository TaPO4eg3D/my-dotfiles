return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    version = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
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
}
