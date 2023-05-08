return {
  -- auto completion
  -- {
  --   "hrsh7th/nvim-cmp",
  --   version = false,
  --   event = "InsertEnter",
  --   dependencies = {
  --     "hrsh7th/cmp-nvim-lsp",
  --     "hrsh7th/cmp-buffer",
  --     "hrsh7th/cmp-path",
  --     "saadparwaiz1/cmp_luasnip",
  --   },
  --   opts = function()
  --     local cmp = require("cmp")
  --     return {
  --       mapping = cmp.mapping.preset.insert({
  --         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  --         ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  --         ["<C-u>"] = cmp.mapping.scroll_docs(4),
  --         ["<C-Space>"] = cmp.mapping.complete(),
  --         ["<C-e>"] = cmp.mapping.abort(),
  --         ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --         ["<S-CR>"] = cmp.mapping.confirm({
  --           behavior = cmp.ConfirmBehavior.Replace,
  --           select = true,
  --         }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --       }),
  --       sources = cmp.config.sources({
  --         { name = "nvim_lsp" },
  --         { name = "buffer" },
  --         { name = "path" },
  --       }),
  --       experimental = {
  --         ghost_text = {
  --           hl_group = "LspCodeLens",
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    "ms-jpq/coq_nvim",
    version = false,
    build = ":COQdeps",
    event = "InsertEnter",
    config = function(plugin, opts)
      vim.cmd[[:COQnow]]
    end
  }
}
