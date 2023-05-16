local utils = require("instance-switcher.utils")

local M = {
  rules = {}
}

local function get_full_path(defined_path)
  local full_path = defined_path
  full_path = string.gsub(full_path, "$%(root%)", vim.loop.cwd())

  return full_path
end

local function process_rules(rules)
  M.rules = {}

  for _, rule in ipairs(rules) do
    if not rule.id then
      utils.notify("Error parsing rules: no ID supplied", vim.log.levels.ERROR)

      return
    end

    if not rule.values then
      utils.notify(
        "You have to supply picker values: (in ID: '" .. rule.id .. "')",
        vim.log.levels.ERROR
      )

      return
    end

    -- TODO: Support defining LUA structs
    local file_content = io.open(rule.values, 'r'):read('*all')

    rule.values = vim.json.decode(file_content)
    rule.file = get_full_path(rule.file)

    M.rules[rule.id] = rule
  end
end

function M.invoke_rule(rule_id)
  local rule = M.rules[rule_id]

  if not rule then
    utils.notify(
      "There is not rule with ID: '" .. rule_id .. "'",
      vim.log.levels.ERROR
    )

    return
  end

  local display_keys = {}
  for key, _ in pairs(rule.values) do
    display_keys[#display_keys + 1] = key
  end

  vim.ui.select(display_keys, {
    prompt = rule.prompt,
  }, function(choice)
      local fd = io.open(rule.file, "r")
      if not fd then
        utils.notify("Cannot open a file: " .. rule.file, vim.log.levels.ERROR)

        return
      end

      local content = fd:read("*all")
      fd:close()

      local pattern = "(" .. rule.env_variable .. ")(%b=\n)"

      local _, capture = string.match(content, pattern)
      local old_value = string.match(capture, "=(.+)\n")

      -- (key_name, payload, old_value)
      local new_value = rule.on_select(choice, rule.values[choice], old_value)

      if not new_value then
        return
      end

      content = string.gsub(content, pattern, "%1=" .. new_value .. "\n", 1)

      fd = io.open(rule.file, "w")
      if not fd then
        utils.notify("Cannot open a file: " .. rule.file, vim.log.levels.ERROR)

        return
      end

      fd:write(content)
      fd:close()
  end)
end

--- Plugin setup
function M.setup(options)
  local opts = options or {}

  if not opts.rules or #opts.rules == 0 then
    utils.notify("No rules supplied!", vim.log.levels.WARN)

    return
  end

  process_rules(opts.rules)
end

return M
