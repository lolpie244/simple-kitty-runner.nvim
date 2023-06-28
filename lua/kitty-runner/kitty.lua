local M = {}
local loop = vim.loop
local utils = require("kitty-runner.utils")
local config = require("kitty-runner.config")
table.unpack = table.unpack or unpack


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
		args = {
			"@", "launch",
			"--cwd", "current",
			"--location", location,
			"--env", "NVIM_KITTY_RUNNER=" .. M.runner_uuid,
			"--env", "PATH=" .. vim.fn.getenv("PATH"),
			table.unpack(config.options.runner.extra_open_runner_args)
		},
	}
	loop.spawn("kitty", options, exit_function)
end

function M.send_to_runner(runner_uuid, command)
	local extra_args = utils.copy(config.options.runner.extra_send_command_args)
	table.insert(extra_args, command .. "\\x0d")

	local options = {
		args = {
			"@", "send-text",
			"--match", "env:NVIM_KITTY_RUNNER=" .. runner_uuid,
			table.unpack(extra_args)
		}
	}

	loop.spawn("kitty", options)
end

function M.launch(command, location)
	local extra_args = utils.copy(config.options.launch.extra_launch_args)
	table.insert(extra_args, command)

	local options = {
		args = {
			"@", "launch",
			"--hold",
			"--cwd", "current",
			"--env", "PATH=" .. vim.fn.getenv("PATH"),
			"--location", location,
			table.unpack(vim.split(command, " ")) 
		}
	}
	loop.spawn("kitty", options)
end

return M
