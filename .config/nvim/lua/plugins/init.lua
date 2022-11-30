local fn = vim.fn

local packerstart =  require('packer').startup(function(use)
    -- Work with "surroundings": parentheses, brackets, quotes and so on
    use("tpope/vim-surround")
    -- Very powerfull plugin for working with Git
    use("tpope/vim-fugitive")
    -- Magit clone for VIM
    use("jreybert/vimagit")
    -- Support for the "dot" command for plugins such as vim-surround and so on
    use("tpope/vim-repeat")
    -- Support for SCSS syntax
    use("cakebaker/scss-syntax.vim")
    -- Nice looking VIM Theme
    use("dracula/vim", {name = 'dracula'})
    use("tpope/vim-commentary")
    use("raimondi/delimitmate")
    use("jlanzarotta/bufexplorer")
    -- Add markdown support
    use("godlygeek/tabular")
    use("plasticboy/vim-markdown")

    -- NeoVIM LSP
    use("neovim/nvim-lspconfig")
    -- Better NeoVIM LSP UI
    use("glepnir/lspsaga.nvim")
    -- NeoVIM Completion
    use("ms-jpq/coq_nvim")

    -- Support for PUG files
    use("digitaltoad/vim-pug")
    -- Support for TypeScript
    use("leafgarland/typescript-vim")
    -- Shows Git info
    use("airblade/vim-gitgutter")
    -- File manager
    use("kyazdani42/nvim-web-devicons")
    use("kyazdani42/nvim-tree.lua")
    -- VIM DevIcons
    use("ryanoasis/vim-devicons")
    -- Automatic tag management
    -- Currently disable since it hans my os while trying to generate tags
    -- call("minpac#add", "ludovicchabant/vim-gutentags")
    -- VimWiki
    use("vimwiki/vimwiki")
    -- Emmet
    use("mattn/emmet-vim")
    -- Zettelkasten
    use("michal-h21/vim-zettel")
    -- Writing tables in markup languages like Markdown becomes really easy
    use("dhruvasagar/vim-table-mode")
    -- Support for discord rich presence, just for lulz
    use("vimsence/vimsence")
    -- Support of Vue.js syntax highlighting
    use("posva/vim-vue")
    -- Support of Treesitter
    use("nvim-treesitter/nvim-treesitter")
    use("nvim-treesitter/playground")
    -- A status line
    use("nvim-lualine/lualine.nvim")
    -- Plenary library
    use("nvim-lua/plenary.nvim")
    -- Telescope
    -- call("minpac#add", "nvim-telescope/telescope.nvim", { tag = "0.1.0" })
    -- FZF
    use("junegunn/fzf", {
        ['do'] = (function ()
            fn['fzf#install']()
        end)
    })
    use("junegunn/fzf.vim")

    -- Magifactor
    -- call("minpac#add", "~/Projects/magifactor")

    -- Debugger
    use("mfussenegger/nvim-dap")
    use("mfussenegger/nvim-dap-python")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")

    -- Optimize Neovim startup by caching lua scripts
    use("lewis6991/impatient.nvim")

    -- Treesitter context
    use("nvim-treesitter/nvim-treesitter-context")

end)

-- Calling configuration
require("plugins.config.lualine")
require("plugins.config.treesitter")
require("plugins.config.nvimtree")
-- require("plugins.config.tscope")
require("plugins.config.fzf")
require("plugins.config.lspsaga")
require("plugins.config.dap")

return packerstart
