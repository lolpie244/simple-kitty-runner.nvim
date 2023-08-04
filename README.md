<p align="center">
  <h1 align="center">simple-kitty-runner.nvim</h1>
</p>

<p align="center">
	Use kitty terminal as runner for the commands directly from neovim
</p>



https://github.com/lolpie244/simple-kitty-runner.nvim/assets/86479624/f1b22912-dd23-4172-b2fc-166d598d77f2


<details>
<summary>Table of Contents</summary>
	<li><a href="#installation">Installation</a></li>
  <li><a href="#configuration">Configuration</a></li>
	<li><a href="#commands">Commands</a></li>
	<li><a href="#api">API</a></li>
	<li><a href="#ssh">SSH</a></li>
	<li><a href="#goal">Goal</a></li>
</details>


## Installation
Install the plugin with your favourite package manager:
<details>
  <summary>lazy.nvim</summary>

```lua
{
  "lolpie244/simple-kitty-runner.nvim",
}
```

</details>

<details>
  <summary>Packer</summary>

```lua
require('packer').startup(function()
    use {
      "lolpie244/simple-kitty-runner.nvim",
    }
end)
```
</details>

## Configuration
``` lua
require("kitty-runner").setup({
	runner = {
		-- default location of runner. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		default_location = "hsplit",
		-- delay between opening runner and sending command.
		delay = 0,
		-- extra arguments for opening runner, Docs: https://sw.kovidgoyal.net/kitty/remote-control/#id14
		extra_open_runner_args = { "--dont-take-focus" },
		-- extra arguments for sending command to runner, docs: https://sw.kovidgoyal.net/kitty/remote-control/#id22
		extra_send_command_args = {},
		-- environment variables, that will be copy to the runner instance
		env_to_copy = { "PATH" }
	},
	launch = {
		-- default location of launch result. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		default_location = "hsplit",
		-- extra arguments for launching to runner. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		extra_launch_args = {},
		-- environment variables, that will be copy to the launcher instance
		env_to_copy = { "PATH" },
	},
    -- socket where kitty is listening. See ssh section
    kitty_listen_on = environment_var("KITTY_LISTEN_ON")

})
```
- - -
## Commands

| Command                       | Description                                                   |
| ----------------------------- | ------------------------------------------------------------ |
| `KittyOpenRunner {location}`  | Open the runner in `{location}` (if not exists)              |
| `KittySendToRunner {command}` | Send `{command}` to the runner. <br />Open new runner in default location, if it doesnt exists |
| `KittyLaunch {command}`       | Launch `{command}` in default location                       |
| `KittyClear`			| Send `clear` command to the runner|
- - -
## API
* `require("kitty-runner").open_runner({location})` \
  Open new runner in *{location}*. If location is not passed - use *runner.default_location* from config
* `require("kitty-runner").send_to_runner({command}, {location})` \
  Send *{command}* to the runner. Opens runner in *{location}*(or in default_location, if location isn't passed) if runner doesn't exists
* `require("kitty-runner").launch({command}, {location})`\
  Launch *{command}* in *{location}* (or in default location, if location isn't passed)
* `require("kitty-runner").clear()` \
  Send clear command to the runner
- - -
## SSH
To work via ssh, plugin requires passing Unix socket from localhost to the server.

You can achieve this using following command:
```bash
kitty +kitten ssh -R /tmp/forwarded:$(echo ${KITTY_LISTEN_ON} | sed "s/.*://g") <ssh_connection>
```
Where:
* `kitty +kitten ssh` - built-in kitty terminal SSH, that allows using splints and tabs
* `-R <socket_name_on_server>:<socket_name_on_localhost>` - passes the Unix socket from localhost to the server
* `$(echo ${KITTY_LISTEN_ON} | sed "s/.*://g")` - retrieves the socket name of the current Kitty instance. This only works if listen_on is in Unix format: /tmp/...

THE After accessing SSH server, you can check the correctness of the socket using command:
```bash
kitty @ --to unix:<socket_name_on_server> ls
```

If everything works correctly, set `kitty_listen_on` in the plugin config to `unix:<socket_name_on_server>`

**Please note that <socket_name_on_server> should be replaced with the actual names of the socket you're using.**
- - -
If you encounter an `"connection refused"` error during the second connection, try removing the `<socket_name_on_server>` file.
Additionally, you can automatically remove the socket upon exiting the SSH server by adding the following line to the server's `.bashrc` (or any startup script):
```bash
function onexit { rm <socket_name_on_server> }; trap onexit EXIT
```
- - -
## Goal
The main goal of this plugin is to provide an API that allows sending commands to kitty via Lua code and keymaps. For example, it can be used in a simple keymap that runs the current Python file:
```lua
function Run()
	local command = string.format("python %s", vim.fn.expand('%:p'))
	require("kitty-runner").send_to_runner(command)
end
keymap("n", "<Leader>r", "<cmd>lua Run()<CR>", opts)
```
