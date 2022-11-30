-- Cache lua, hence optimize startup
require('impatient')

require("plugins")
require("lsp")
require("settings")
require("mappings")

-- TODO: Move to autocmd or smth
-- Automatically close all foldings
vim.api.nvim_create_autocmd({"BufReadPost", "FileReadPost"}, {
   pattern = "*",
   callback = (function ()
        vim.api.nvim_command('normal zR')
   end)
})

require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "c",
        "cpp",
        "lua",
        'html',
        'python',
        "rust"
    },
    highlight = {
        enable = true
    }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax=3
vim.opt.foldminlines=1
