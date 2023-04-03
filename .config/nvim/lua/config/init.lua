local M = {}

M.did_init = false
M.colorscheme = "tokyonight"

function M.load(name)
	local Util = require("lazy.core.util")

	local function _load(mod)
		Util.try(function()
			require(mod)
		end, {
			msg = "Failed loading " .. mod,
			on_error = function(msg)
				local info = require("lazy.core.cache").find(mod)
				if info == nil or (type(info) == "table" and #info == 0) then
					return
				end
				Util.error(msg)
			end,
		})
	end

	_load("config." .. name)
end

function M.init()
	if not M.did_init then
		M.did_init = true
		-- delay notifications till vim.notify was replaced or after 500ms
		require("utils.general").lazy_notify()

		-- load options here, before lazy init while sourcing plugin modules
		-- this is needed to make sure options will be correctly applied
		-- after installing missing plugins
		require("config").load("options")

		M.load("autocmds")
		M.load("keymaps")

		require(M.colorscheme).load({
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})
	end
end

return M
