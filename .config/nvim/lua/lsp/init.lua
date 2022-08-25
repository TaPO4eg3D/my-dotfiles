local cmd = vim.cmd

cmd("packadd! nvim-lspconfig")

require "lsp.python"
require "lsp.tscript"
require "lsp.css"
require "lsp.clangs"
require "lsp.rust"
require "lsp.html"
require "lsp.vue"
require "lsp.lua"

local saga = require "lspsaga"
saga.init_lsp_saga()
