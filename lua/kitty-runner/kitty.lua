local M = {}
local loop = vim.loop
local utils = require("kitty-runner.utils")
local config = require("kitty-runner.config")
table.unpack = table.unpack or unpack


local function get_env_variables(variables)
	-- Return env variables in format: {"--env", "key1=val1", "--env", "key2=val2", ... }
	local result = {}
	for _, variable in pairs(variables) do
		table.insert(result, "--env")
		table.insert(result, string.format("%s=%s", variable, vim.fn.getenv(variable)))
	end
	return result
end

function M.is_runner_exists(id)
	if id == nil then
		return false
	end

	-- run kitty @ ls for getting all windows, and search line that contains "NVIM_KITTY_RUNNER": "runner_id"
	local command = string.format([[kitty @ ls | grep -c '"NVIM_KITTY_RUNNER": *"%s"']], id)
	local handle = io.popen(command)
	local window_exists = handle:read("n")

	handle:close()
	return window_exists ~= 0
end

function M.open_runner(location, exit_function)
	M.runner_uuid = utils.get_uuid()
	local options = {
		args = utils.merge_arrays({
				"@", "launch",
				"--cwd", "current",
				"--location", location,
				"--env", "NVIM_KITTY_RUNNER=" .. M.runner_uuid
			},
			get_env_variables(config.options.runner.env_to_copy),
			config.options.runner.extra_open_runner_args
		)
	}
	loop.spawn("kitty", options, exit_function)
end

function M.send_to_runner(runner_uuid, command)
	if runner_uuid == nil then
		return
	end

	local options = {
		args = utils.merge_arrays({
				"@", "send-text",
				"--match", "env:NVIM_KITTY_RUNNER=" .. runner_uuid
			},
			utils.copy(config.options.runner.extra_send_command_args),
			{ command .. "\\x0d" }
		)
	}

	loop.spawn("kitty", options)
end

function M.launch(command, location)
	local disable_cursor = [[tput civis]]
	local press_to_continue = [[
	echo
	echo -en "\033[0;32mPress any key to exit"
	read -rsn1
]]
	local options = {
		args = utils.merge_arrays({
				"@", "launch",
				"--cwd", "current",
				"--location", location,
			},
			get_env_variables(config.options.launch.env_to_copy),
			utils.copy(config.options.launch.extra_launch_args),
			{ "sh", "-c",
				disable_cursor .. ";" .. command .. ";" .. press_to_continue }
		)
	}
	loop.spawn("kitty", options)
end

return M
