local fn = vim.fn
local cmd = vim.cmd
local call = vim.call

-- TODO: Refactor this module to reduce the boilerplate
-- for calling the minpac#update function

cmd.packadd("minpac")
call("minpac#init")

-- Work with "surroundings": parentheses, brackets, quotes and so on
call("minpac#add", "tpope/vim-surround")
-- Very powerfull plugin for working with Git
call("minpac#add", "tpope/vim-fugitive")
-- Magit clone for VIM
call("minpac#add", "jreybert/vimagit")
-- Support for the "dot" command for plugins such as vim-surround and so on
call("minpac#add", "tpope/vim-repeat")
-- Support for SCSS syntax
call("minpac#add", "cakebaker/scss-syntax.vim")
-- Nice looking VIM Theme
call("minpac#add", "dracula/vim", {name = 'dracula'})
call("minpac#add", "tpope/vim-commentary")
call("minpac#add", "jlanzarotta/bufexplorer")
call("minpac#add", "raimondi/delimitmate")
-- Add markdown support
call("minpac#add", "godlygeek/tabular")
call("minpac#add", "plasticboy/vim-markdown")

-- NeoVIM LSP
call("minpac#add", "neovim/nvim-lspconfig")
-- Better NeoVIM LSP UI
call("minpac#add", "glepnir/lspsaga.nvim")
-- NeoVIM Completion
call("minpac#add", "ms-jpq/coq_nvim")

-- Support for PUG files
call("minpac#add", "digitaltoad/vim-pug")
-- Support for TypeScript
call("minpac#add", "leafgarland/typescript-vim")
-- Shows Git info
call("minpac#add", "airblade/vim-gitgutter")
-- File manager
call("minpac#add", "kyazdani42/nvim-web-devicons")
call("minpac#add", "kyazdani42/nvim-tree.lua")
-- VIM DevIcons
call("minpac#add", "ryanoasis/vim-devicons")
-- Automatic tag management
call("minpac#add", "ludovicchabant/vim-gutentags")
-- VimWiki
call("minpac#add", "vimwiki/vimwiki")
-- Emmet
call("minpac#add", "mattn/emmet-vim")
-- Zettelkasten
call("minpac#add", "michal-h21/vim-zettel")
-- Writing tables in markup languages like Markdown becomes really easy
call("minpac#add", "dhruvasagar/vim-table-mode")
-- Support for discord rich presence, just for lulz
call("minpac#add", "vimsence/vimsence")
-- Support of Vue.js syntax highlighting
call("minpac#add", "posva/vim-vue")
-- Support of Treesitter
call("minpac#add", "nvim-treesitter/nvim-treesitter")
call("minpac#add", "nvim-treesitter/playground")
-- Support of refactoring features for Python
call("minpac#add", "python-rope/ropevim")
-- A status line
call("minpac#add", "nvim-lualine/lualine.nvim")
-- Plenary library
call("minpac#add", "nvim-lua/plenary.nvim")
-- Telescope
-- call("minpac#add", "nvim-telescope/telescope.nvim", { tag = "0.1.0" })
-- FZF
call("minpac#add", "junegunn/fzf", {
    ['do'] = (function ()
        fn['fzf#install']()
    end)
})
call("minpac#add", "junegunn/fzf.vim")

-- Magifactor
-- call("minpac#add", "~/Projects/magifactor")

-- Debugger
call("minpac#add", "mfussenegger/nvim-dap")
call("minpac#add", "mfussenegger/nvim-dap-python")
call("minpac#add", "rcarriga/nvim-dap-ui")
call("minpac#add", "theHamsta/nvim-dap-virtual-text")

-- Fix performance for CursorHold. Probably delete when the fix is in upstream
call("minpac#add", "antoinemadec/FixCursorHold.nvim")

-- Calling configuration
require("plugins.config.lualine")
require("plugins.config.treesitter")
require("plugins.config.nvimtree")
-- require("plugins.config.tscope")
require("plugins.config.fzf")
require("plugins.config.lspsaga")
require("plugins.config.dap")
