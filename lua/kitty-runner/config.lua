local config = {}

config.options = {
	runner = {
		default_location = "hsplit", -- default location of runner. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		delay = 0,             -- delay between opening runner and sending command
		extra_open_runner_args = { "--dont-take-focus" }, -- extra arguments for opening runner, Docs: https://sw.kovidgoyal.net/kitty/remote-control/#id14
		extra_send_command_args = {}, -- extra arguments for sending command to runner, docs: https://sw.kovidgoyal.net/kitty/remote-control/#id22
		env_to_copy = { "PATH" }
	},
	launch = {
		default_location = "hsplit", -- default location of launch result. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		extra_launch_args = {}, -- extra arguments for launching to runner. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		env_to_copy = { "PATH" },
	}
}

function config.set_options(opts)
	opts = opts or {}
	config.options = vim.tbl_deep_extend("force", config.options, opts)
end

return config
