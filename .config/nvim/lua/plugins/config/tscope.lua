-- require('telescope').setup({
--     defaults = {
--         mappings = {
--             i = {
--                 ["<C-j>"] = "move_selection_next",
--                 ["<C-k>"] = "move_selection_previous",
--             }
--         },
--     },
-- })

-- local M = {}

-- function M.live_grep_no_test()
--     require("telescope.builtin").live_grep(
--         {
--             glob_pattern = {
--                 "!tests", "!test",
--             },
--         }
--     )
-- end

-- return M
