local M = {}
local loop = vim.loop
local utils = require("kitty-runner.utils")
local config = require("kitty-runner.config").options


function M.is_runner_exists(id)
	if id == nil then
		return false
	end

	local command = string.format([[kitty @ ls | grep -c '"NVIM_KITTY_RUNNER": *"%s"']], id)
	local handle = io.popen(command)
	local window_exists = handle:read("n")

	handle:close()
	return window_exists ~= 0
end

function M.open_runner(location, exit_function)
	M.runner_uuid = utils.get_uuid()
	local options = {
		args = { "@", "launch", "--location", location, "--env", "NVIM_KITTY_RUNNER=" .. M.runner_uuid,
			},
	}
	loop.spawn("kitty", options, exit_function)
end

function M.send_to_runner(runner_uuid, command)
	local options = {
		args = { "@", "send-text", "--match", "env:NVIM_KITTY_RUNNER=" .. runner_uuid,
			command .. "\\x0d" }
	}
	
	loop.spawn("kitty", options)
end

function M.launch(command, location)
	local options = {
		args = { "@", "launch", "--hold", "--location", location, command }
	}
	loop.spawn("kitty", options)
end

return M
