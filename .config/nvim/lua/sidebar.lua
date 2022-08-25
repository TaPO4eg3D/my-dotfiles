local parsers = require 'nvim-treesitter.parsers'
local ts_utils = require 'nvim-treesitter.ts_utils'
local a = vim.api


local M = {}
local get_node_text = vim.treesitter.query.get_node_text


local function dd_insert(target, key, value)
  if not target[key] then
    target[key] = {}
  end

  table.insert(target[key], value)
end

local function get_element_name(node)
  local element_name = nil

  for inner_child, _ in node:iter_children() do
    if inner_child:type() == 'identifier' then
      element_name = get_node_text(inner_child, 0)
      break
    end
  end

  return element_name
end

local function get_argument_info(node)
  local argument = {}

  if node:type() == 'identifier' then
    -- Positional untyped argumement
    argument.name = get_node_text(node, 0)
  else
    -- Typed or Default or Typed-Default
    for argument_child, field in node:iter_children() do
      local text = get_node_text(argument_child, 0)

      if argument_child:type() == 'identifier' then
        argument.name = text
      elseif argument_child:type() == 'type' then
        argument.type = text
      elseif field == 'value' then
        argument.value = text
      end
    end
  end

  return argument
end

local function get_function_arguments(node)
  local arguments = {}
  local parameters_node = nil

  for child, _ in node:iter_children() do
    if child:type() == 'parameters' then
      parameters_node = child
      break
    end
  end

  if parameters_node == nil then
    return arguments
  end

  for child, _ in parameters_node:iter_children() do
    if child:named() then
      table.insert(arguments, get_argument_info(child))
    end
  end

  return arguments
end

local function parse_function(node)
  return {
    name = get_element_name(node),
    arguments = get_function_arguments(node)
  }
end

local function get_superclasses(node)
  local classes = {}

  for child, _ in node:iter_children() do
    if child:type() == 'identifier' then
      table.insert(classes, get_node_text(child, 0))
    end
  end

  return classes
end

local function get_class_functions(node)
  local functions = {}

  for child, _ in node:iter_children() do
    if child:type() == 'function_definition' then
      table.insert(functions, parse_function(child))
    end
  end

  return functions
end

local function parse_class(node)
  local class_info = {}

  for child, field in node:iter_children() do
    if field == 'name' then
      class_info.name = get_node_text(child, 0)
    end

    if field == 'superclasses' then
      class_info.superclasses = get_superclasses(child)
    end

    if field == 'body' then
      class_info.functions = get_class_functions(child)
    end
  end

  return class_info
end

local function process_tree(tree)
  local root = tree:root()
  local found_elements = {}

  for child, _ in root:iter_children() do -- Find functions and classes
    local key = nil
    local parser = nil

    local node_type = child:type()

    if node_type == 'function_definition' then
      key = 'functions'
      parser = parse_function
    elseif node_type == 'class_definition' then
      key = 'classes'
      parser = parse_class
    end

    if key then
      dd_insert(found_elements, key, parser(child))
    end
  end

  return found_elements
end

function M.parse_file()
    -- TODO: Form structures to store function and classes
    local parser = parsers.get_parser(0)
    local trees = parser:parse()

    for i = 1, #trees do
      -- TODO: Render each tree later, just the first one for now
      return process_tree(trees[i])
    end
end

local function render_function_arguments(indent, arguments)
  local lines = {}

  local prefix = '- ARG: '
  local type_prefix = '- TYPE: '
  local value_prefix = '- DEFAULT: '

  for _, argument in ipairs(arguments) do
    local local_indent = ""

    if indent > 0 then
      local_indent = string.rep(" ", indent)
    end

    -- - ARG: NAME
    table.insert(
      lines,
      {string.format(
        "%s%s%s", local_indent,
        prefix, argument.name
      ), {
        hl_group = 'String',
        col_start = indent + 2,
        col_end = indent + 6
      }}
    )

    local_indent = local_indent .. string.rep(" ", 4)

    -- - TYPE: TYPE
    if argument.type then
      table.insert(
        lines,
        {string.format(
          "%s%s%s", local_indent,
          type_prefix, argument.type
        )}
      )
    end

    if argument.value then
      table.insert(
        lines,
        {string.format(
          "%s%s%s", local_indent,
          value_prefix, argument.value
        )}
      )
    end
  end

  return lines
end

local function render_functions(funcs, indent)
  if funcs == nil then
    return {}
  end

  local lines = {}
  indent = indent or 0

  for _, func in ipairs(funcs) do
    local local_indent = ""

    if indent > 0 then
      local_indent = string.rep(" ", indent)
    end

    local line = string.format("%s%s", local_indent, func.name)

    table.insert(lines, {
      line, {
        hl_group = 'Function',
        col_start = indent,
        col_end = -1
      },
    })

    local argument_lines = render_function_arguments(
      indent + 4, func.arguments
    )

    for _, argument_line in ipairs(argument_lines) do
      table.insert(lines, argument_line)
    end

    table.insert(lines, {""})
  end

  return lines
end

local function render_superclasses(class_names, indent)
  if class_names == nil then
    return {}
  end

  local local_indent = string.rep(" ", indent)
  local lines = {
    {string.format("%sSUPERCLASSES: ", local_indent)},
  }

  local_indent = local_indent .. string.rep(" ", 4)
  for _, class_name in ipairs(class_names) do
    table.insert(
      lines,
      {string.format("%s- %s", local_indent, class_name)}
    )
  end

  return lines
end

local function render_classes(classes, indent)
  if classes == nil then
    return {}
  end

  local lines = {}
  indent = indent or 0

  for _, class in ipairs(classes) do
    local local_indent = ""

    if indent > 0 then
      local_indent = string.rep(" ", indent)
    end

    local line = string.format("%s%s", local_indent, class.name)
    table.insert(lines, {line})

    local superclass_lines = render_superclasses(class.superclasses, indent + 4)
    for _, superclass_line in ipairs(superclass_lines) do
      table.insert(lines, superclass_line)
    end

    if #superclass_lines > 0 then
      table.insert(lines, {""})
    end

    local func_lines = render_functions(class.functions, indent + 4)
    for _, func_line in ipairs(func_lines) do
      table.insert(lines, func_line)
    end
  end

  return lines
end

local function render()
  local lines = {}
  local highlights = {}

  local file_info = M.parse_file()

  local func_lines = render_functions(file_info.functions)
  for _, func_line in ipairs(func_lines) do
    table.insert(lines, func_line[1])

    if #func_line > 1 then
      local current_line = #lines - 1
      for i = 2, #func_line do
        func_line[i].line = current_line
        table.insert(highlights, func_line[i])
      end
    end
  end

  local class_lines = render_classes(file_info.classes)
  for _, class_line in ipairs(class_lines) do
    table.insert(lines, class_line[1])

    if #class_line > 1 then
      local current_line = #lines - 1
      for i = 2, #class_line do
        class_line[i].line = current_line
        table.insert(highlights, class_line[i])
      end
    end
  end

  a.nvim_buf_set_lines(M.buf, 0, -1, false, lines)

  for _, highlight in ipairs(highlights) do
    a.nvim_buf_add_highlight(
      M.buf, -1,
      highlight.hl_group, highlight.line,
      highlight.col_start, highlight.col_end
    )
  end
end

local function create_buffer()
  local buf = a.nvim_create_buf(false, false)

  a.nvim_buf_set_option(buf, "buftype", "nofile")
  a.nvim_buf_set_option(buf, "swapfile", false)
  a.nvim_buf_set_option(buf, "buflisted", false)
  a.nvim_buf_set_option(buf, "filetype", "file-structure")

  return buf
end

local function create_window()
  local current_window = a.nvim_get_current_win()
  vim.cmd("vsp")
  local new_window = a.nvim_get_current_win()

  vim.cmd(string.format("buffer %d", M.buf))

  a.nvim_win_set_option(0, "spell", false)
  a.nvim_win_set_option(0, "number", false)
  a.nvim_win_set_option(0, "relativenumber", false)
  a.nvim_win_set_option(0, "cursorline", false)

  a.nvim_set_current_win(current_window)

  -- TOOD: Implement resizing
  return new_window
end

function M.open()
  M.buf = create_buffer()
  M.win = create_window()

  render()
end

return M
