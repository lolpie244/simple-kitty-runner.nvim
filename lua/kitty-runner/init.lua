local M = {}

local config = require("kitty-runner.config")
local kitty = require("kitty-runner.kitty") -- kitty adapter

function M.setup(opts)
	config.set_options(opts)
end

function M.open_runner(location)
	location = (location ~= "" and location) or config.options.runner.default_location
	location = location:match("^%s*(.-)%s*$")

	if not kitty.is_runner_exists(kitty.runner_uuid) then
		kitty.open_runner(location)
	end
end

function M.send_to_runner(command, location)
	location = location or config.options.runner.default_location

	if not kitty.is_runner_exists(kitty.runner_uuid) then
		-- If runner not exists - create runner, and run command with delay
		kitty.open_runner(location, function(status)
			vim.defer_fn(function() kitty.send_to_runner(kitty.runner_uuid, command) end, config.options.runner.delay)
		end)
	else
		kitty.send_to_runner(kitty.runner_uuid, command)
	end
end

function M.launch(command, location)
	location = location or config.options.launch.default_location
	kitty.launch(command, location)
end

function M.clear()
	kitty.send_to_runner(kitty.runner_uuid, "clear")
end

return M
