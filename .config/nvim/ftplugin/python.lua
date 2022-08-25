local m = require("mappings")

m.map("n", "<leader>rc", [[<cmd>lua require('utils.python').copy_python_path()<CR>]])
