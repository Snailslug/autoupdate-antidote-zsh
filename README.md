# autoupdate-antibody-zsh

Antibody doesn't do automatic updates like [oh-my-zsh](https://github.com/oh-my-zsh/oh-my-zsh). Set up easy
auto updating, both of antibody and the bundles loaded in your configuration.

Activate with `antibody bundle spikespaz/autoupdate-antibody-zsh`

## Customization

set `ANTIBODY_PLUGIN_UPDATE_DAYS` before calling the bundle if you don't want
the default value of 7 days.

set `ANTIBODY_SYSTEM_UPDATE_DAYS` before calling the bundle if you don't want
the default value of 7 days.

These values must be integers.
