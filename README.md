# autoupdate-antibody-zsh

Antibody doesn't do automatic updates like [oh-my-zsh][0].
Set up easy auto updating of the bundles loaded in your configuration.

It also will automatically check your `~/.zsh_plugins.txt` and bundle again if it was modified.
See information about [static loading][1] on Antibody's homepage.

Activate with `antibody bundle spikespaz/autoupdate-antibody-zsh`.

<sub>See [why not oh-my-zsh][2].</sub>

## Customization

There are numerous global variables that will be set with defaults if they are undefined. You may override these in your `.zshrc`.

**Note:** If you are using the default names for the files described in the [static loading][1] section of Antibody's website, they will be automatically detected, if they exist. This script will not create them for you, and the corresponding feature is disabled. 

| Global | Default | Purpose |
| ------ | ------- | ------- |
| `ANTIBODY_AUTOUPDATE_VERBOSE` | `true` | Display what this script is doing after checking whether it should update, if anything. Must be a boolean. |
| `ANTIBODY_PLUGIN_UPDATE_DAYS` | `7` | The interval of days to update ypur bundles, checked every time a prompt is launched. Must be an integer. |
| `ANTIBODY_PLUGIN_LIST_F` | `"$HOME/.zsh_plugins.txt"` | If you are [loading your plugins statically][1], this is the path to the file that lists them. Must be a string with a valid path to an existing file. |
| `ANTIBODY_PLUGIN_SOURCE_F` | `"$HOME/.zsh_plugins.sh"` | With static loading, this is the file that is sourced by your `.zshrc`. Must also be a valid file path. |
| `ANTIBODY_PLUGIN_RECEIPT_F` | `"$HOME/.antibody_plugin_lastupdate"` | This is the path to the receipt file that is used to keep track of the last update time. Must be a path as a string, it will be created for you on the first run. |



[0]: https://github.com/oh-my-zsh/oh-my-zsh
[1]: https://getantibody.github.io/#static-loading
[2]: https://www.youtube.com/watch?v=hLxr9hLfO0Q