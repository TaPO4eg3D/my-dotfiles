-- Lua specif config file, a candidate to replace init.vim in future

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "javascript" },
  sync_install = false,

  highlight = {
    enable = true,
  },

  indent = {
    enable = true,
  }
}
