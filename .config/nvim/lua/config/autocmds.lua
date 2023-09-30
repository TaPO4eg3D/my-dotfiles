-- In order to not conflict with builtin diff keymaps
-- Not sure if's efficient tho
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(data)
    if vim.o.diff then
      vim.keymap.set("n", "]c", "]c", {
        buffer = data.buf
      })
      vim.keymap.set("n", "[c", "[c", {
        buffer = data.buf
      })
    end
  end
})
