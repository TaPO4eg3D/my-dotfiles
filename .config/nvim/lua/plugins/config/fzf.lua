local M = {}

local rg_default = "rg --column --line-number --no-heading --color=always --smart-case"

function M.fzf_no_tests()
    local rg_command = rg_default .. " -g '!test' -g '!tests' ''"
    local fprev = vim.fn["fzf#vim#with_preview"]()
    vim.fn["fzf#vim#grep"](rg_command, 1, fprev, true)
end

return M
