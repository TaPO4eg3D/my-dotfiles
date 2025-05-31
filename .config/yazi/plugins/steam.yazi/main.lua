local state = ya.sync(function() return cx.active.current.cwd end)

local exec_fzf = ya.sync(function ()
  return io.popen("fzf < /tmp/game_list.txt")
end)

local function fail(s, ...) ya.notify { title = "Fzf", content = string.format(s, ...), timeout = 5, level = "error" } end

local function parse_games()
	local child, err =
		Command("protontricks")
      :args({ "-l" })
      :stdout(Command.PIPED)
      :spawn()

	if not child then
		return fail("Failed to start `protontricks`, error: " .. err)
	end

	local output, err = child:wait_with_output()

	if not output then
		return fail("Cannot read `protontricks` output, error: " .. err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("`protontricks` exited with error code %s", output.status.code)
	end

  -- Initialize an empty table to hold the games
  local games = {}

  -- Iterate over each line of the output
  for line in output.stdout:gmatch("[^\r\n]+") do
    -- Match lines that follow the pattern: Game Name (Game ID)
    local gameName, gameID = line:match("^%s*(.-)%s*%((%d+)%)%s*$")
    if gameName and gameID then
      games[gameName] = tonumber(gameID)
    end
  end

  local tmpfile = "/tmp/game_list.txt"
  local file = io.open(tmpfile, "w")
  if file then
    for name, _ in pairs(games) do
      file:write(name .. "\n")
    end
    file:close()
  end
end

local function entry()
	local _permit = ya.hide()

  local games = parse_games()

  local handle = exec_fzf()
  handle:close()

	local child, err =
		Command("cat")
      :stdin(Command.INHERIT)
      :stdout(Command.PIPED)
      :stderr(Command.INHERIT):spawn()

	if not child then
		return fail("Failed to start `fzf`, error: " .. err)
	end

	local output, err = child:wait_with_output()
	if not output then
		return fail("Cannot read `fzf` output, error: " .. err)
	elseif not output.status.success and output.status.code ~= 130 then
		return fail("`fzf` exited with error code %s", output.status.code)
	end

	local target = output.stdout:gsub("\n$", "")
	if target ~= "" then
		ya.mgr_emit(target:find("[/\\]$") and "cd" or "reveal", { target })
	end
end

return { entry = entry }
