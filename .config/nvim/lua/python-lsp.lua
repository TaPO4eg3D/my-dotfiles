require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}

-- python-language-server
-- local lspconfig = require 'lspconfig'

-- lspconfig.pyls.setup({
--   on_attach = require'completion'.on_attach;
--   settings = {
--     pyls = {
--       plugins = {
--         jedi_completion = {
--           fuzzy = true;
--         };
--         pyls_mypy = {
--           enabled = true;
--         };
--         pycodestyle = {
--           maxLineLength = 120;
--         };
--       };
--     };
--   };
-- });
