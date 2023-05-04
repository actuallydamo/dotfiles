#!/usr/bin/env bash
#
# Run this one after you've got an OS installed, and you're logged in as a user
#

set -euo pipefail

export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state

localectl set-locale LANG=en_AU.UTF-8
export LANG=en_AU.UTF-8

export GNUPGHOME="$XDG_DATA_HOME"/gnupg
mkdir "$GNUPGHOME" -p
chmod 700 "$GNUPGHOME"

# Import GPG public keys
keys=(
    "7A3A762FAFD4A51F" # Spotify
    "A2C794A986419D8A" # libc++
    "E89ABC254FF3F297" # Me
)
gpg --keyserver hkp://keyserver.ubuntu.com:80 --receive-keys "${keys[@]}"

#
# Aura
#
if ! [ -x "$(command -v aura)" ]; then
    git clone https://aur.archlinux.org/aura-bin.git /tmp/aura-bin
    cd /tmp/aura-bin || exit
    makepkg
    sudo pacman -U --noconfirm /tmp/aura-bin/*.pkg.tar.zst
    cd - || exit
fi

export PATH="$PATH:$HOME/.cargo/bin"

sudo pacman -Syu

echo "Installing pacman packages..."
readarray -t pacman_packages <<< "$(comm -12 <(pacman -Slq | sort) <(sort "$HOME"/.dotfiles/setup/pacman))"
sudo pacman -S --noconfirm --needed "${pacman_packages[@]}"

echo "Installing AUR packages..."
readarray -t aura_packages <<< "$(cat "$HOME"/.dotfiles/setup/aur)"
sudo aura -A --needed --noconfirm "${aura_packages[@]}"

# Enable audio
systemctl --user enable --now pipewire-pulse

# When running on a laptop
if [ -f "/sys/class/power_supply/BAT0/capacity0" ]; then
    echo "Installing pacman laptop packages..."
    readarray -t pacman_packages < <(pacman -Slq | sort) <(sort "$HOME"/.dotfiles/setup/pacman-laptop)
    sudo pacman -S --noconfirm --needed "${pacman_packages[@]}"

    echo "Installing AUR laptop packages..."
    readarray -t aura_packages <<< "$(cat "$HOME"/.dotfiles/setup/aur-laptop)"
    sudo aura -A --noconfirm "${aura_packages[@]}"

    # Enable bluetooh
    sudo systemctl enable --now bluetooh
fi

# Install rust
export CARGO_HOME="$XDG_DATA_HOME"/cargo
rustup install stable
rustup default stable

# Oh My ZSH
if [ "$ZSH" != yes ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# NVM
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -e "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
[ -e "$NVM_DIR/nvm.sh" ] || ln -s /usr/share/nvm/nvm.sh "$NVM_DIR/nvm.sh"
[ -e "$NVM_DIR/nvm-exec" ] || ln -s /usr/share/nvm/nvm-exec "$NVM_DIR/nvm-exec"

# ZSH Autosuggestions link from aur package to plugin folder
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    ln -s /usr/share/zsh/plugins/zsh-autosuggestions "$HOME"/.oh-my-zsh/plugins/zsh-autosuggestions
fi

if [ ! -f "/usr/local/bin/rofi-power-menu" ]; then
    sudo curl "https://raw.githubusercontent.com/jluttine/rofi-power-menu/master/rofi-power-menu" -o "/usr/local/bin/rofi-power-menu"
fi

# Fresh
rm -f ~/.zshrc
bash -c "$(curl -sL get.freshshell.com)"
rm -f ~/.freshrc
ln -s ~/.dotfiles/freshrc ~/.freshrc

echo "Done. Time to log out and in again!"
