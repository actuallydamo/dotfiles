# dotfiles

dotfiles is a set of scripts and configurations to set up Arch Linux with the applications I develop with, and programs I use most.

My dotfiles are managed by [fresh](http://freshshell.com).

## Requirements

1. A computer capable of running Arch Linux

## Get started

1. Boot into an Arch Live boot
2. Connect to wifi `sudo systemctl start iwd` `iwctl` `station wlan0 connect SSID`
3. Run the setup script `/bin/bash -c "$(curl -fsSL https://t.ly/P8XN)"`
4. Reboot into the newly installed system, and log in.
5. Connect to wifi `iwctl`
6. From `~/.dotfiles`, run `./setup/setup.sh`
7. Reboot
