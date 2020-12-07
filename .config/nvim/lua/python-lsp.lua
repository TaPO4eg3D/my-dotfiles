local nvim_lsp = require 'nvim_lsp'

nvim_lsp.pyls.setup({
  on_attach = require'completion'.on_attach;
  settings = {
    pyls = {
      plugins = {
        jedi_completion = {
          fuzzy = true;
        };
        pyls_mypy = {
          enabled = true;
        };
        pycodestyle = {
          maxLineLength = 120;
        };
      };
    };
  };
});
