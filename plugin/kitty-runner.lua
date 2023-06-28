if vim.g.loaded_kitty_runner then
	return
end
vim.g.loaded_kitty_runner = true

local command = vim.api.nvim_create_user_command

command("KittyOpenRunner", function(opts)
	require("kitty-runner").open_runner(opts.args)
end, {
	nargs = "?",
	complete = function(_, _, _)
		return require("kitty-runner.constants").kitty.location
	end
})

command("KittySendToRunner", function(opts)
	require("kitty-runner").send_to_runner(opts.args)
end, { nargs = 1, complete = "shellcmd" })


command("KittyLaunch", function(opts)
	require("kitty-runner").launch(opts.args)
end, { nargs = 1, complete = "shellcmd" })
