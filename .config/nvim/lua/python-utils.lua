local ts_utils = require('nvim-treesitter.ts_utils')

local M = {}

function M.get_module_path()
  local cursor_node = ts_utils.get_node_at_cursor()
  local cn_type = cursor_node:type()

  if cn_type == "identifier" then
    local parent_node = cursor_node:parent()
    local parent_type = parent_node:type()

    if parent_type ~= 'function_definition' and parent_type ~= 'class_definition' then
      print('Cursor is not on a function or a class!')

      return
    end
  elseif cn_type ~= 'function_definition' and cn_type ~= 'class_definition' then
    print('Cursor is not on a function or a class!')

    return
  end

  local curr_node = cursor_node
  local module_path = ''

  while true do
    local curr_node_type = curr_node:type()

    if curr_node_type == 'function_definition' or curr_node_type == 'class_definition' then
      local identifier = curr_node:named_child(0)
      local id_text = ts_utils.get_node_text(identifier, 0)[1]

      if module_path == '' then
        module_path = id_text
      else
        module_path = id_text .. '.' .. module_path
      end

    end

    if curr_node_type == 'module' then
      break
    end

    curr_node = curr_node:parent()
  end

  local file_path = vim.fn.expand('%p')
  file_path = file_path:gsub('%.%w+$', '') -- remove file extension
  file_path = file_path:gsub('/', '.')

  local full_path = file_path .. '.' .. module_path

  return full_path
end

return M
