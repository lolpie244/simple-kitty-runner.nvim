local config = {}

config.options = {
	runner = {
		default_location = "hsplit",
		delay = 70,
		extra_open_runner_args = {},
		extra_send_command_args = {},
	},
	launch = {
		default_location = "hsplit",
		extra_launch_args = {},
	}
}

function config.set_options(opts)
	opts = opts or {}
	config.options = vim.tbl_deep_extend("keep", opts, config.options)
end

return config
