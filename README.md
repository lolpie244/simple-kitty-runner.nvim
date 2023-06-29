<p align="center">
  <h1 align="center">simple-kitty-runner.nvim</h1>
</p>

<p align="center">
	Use kitty terminal as runner for the commands directly from neovim
</p>

[simple-kitty-runner-demo.webm](https://github.com/lolpie244/simple-kitty-runner.nvim/assets/86479624/cd5df266-ba80-452d-abd5-672cd4ea7899)

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
		extra_open_runner_args = {},
		-- extra arguments for sending command to runner, docs: https://sw.kovidgoyal.net/kitty/remote-control/#id22
		extra_send_command_args = {},
		-- environment variables, that will be copy to the runner instance
		env_to_copy = { "PATH", "VIRTUAL_ENV" }
	},
	launch = {
		-- default location of launch result. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		default_location = "hsplit",
		-- extra arguments for launching to runner. Docs: https://sw.kovidgoyal.net/kitty/remote-control/#cmdoption-kitty-launch-location
		extra_launch_args = {},
		-- environment variables, that will be copy to the launcher instance
		env_to_copy = { "PATH", "VIRTUAL_ENV" },
	}

})
```
## Commands

| Command                       | Description                                                   |
| ----------------------------- | ------------------------------------------------------------ |
| `KittyOpenRunner {location}`  | Open the runner in `{location}` (if not exists)              |
| `KittySendToRunner {command}` | Send `{command}` to the runner. <br />Open new runner in default location, if it doesnt exists |
| `KittyLaunch {command}`       | Launch `{command}` in default location                       |
## API
* `require("kitty-runner").open_runner({location})` \
  Open new runner in *{location}*. If location is not passed - use *runner.default_location* from config
* `require("kitty-runner").send_to_runner({command}, {location})` \
  Send *{command}* to the runner. Opens runner in *{location}*(or in default_location, if location isn't passed) if runner doesn't exists
* `require("kitty-runner").launch({command}, {location})`\
  Launch *{command}* in *{location}* (or in default location, if location isn't passed)
