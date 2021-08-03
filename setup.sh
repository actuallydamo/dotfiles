#!/bin/bash
set -euo pipefail

# Terraform repo setup
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(grep DISTRIB_CODENAME= /etc/upstream-release/lsb-release | awk -F = '{print $(2)}') main"

# Prerequisites
sudo apt update
sudo apt install -y \
  cmake \
  direnv \
  flameshot \
  fzf \
  git \
  git-lfs \
  jq \
  libicu-dev \
  libmysqlclient-dev \
  libpq-dev \
  make \
  mariadb-client \
  pv \
  redis-tools \
  ruby-dev \
  scdaemon \
  terraform \
  tmate \
  v4l-utils \
  wkhtmltopdf \
  zsh

# Get version of latest release of a GitHub repository
github_release () {
  curl -s "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

install_deb_from_url () {
  TEMP_DEB="$(mktemp)" &&
  wget -O "$TEMP_DEB" "$1" &&
  sudo dpkg -i "$TEMP_DEB"
  rm -f "$TEMP_DEB"
}

# Grab my GPG Public Key
gpg --keyserver hkp://keyserver.ubuntu.com:80 --receive-keys E89ABC254FF3F297

# Starship Install
sudo curl -fsSL https://starship.rs/install.sh | bash -s -- -f

# oh-my-zsh Install
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# zsh-autosuggestions Install
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# zsh config
rm ~/.zshrc
ln -s ~/.dotfiles/zshrc ~/.zshrc

# Install Hack Nerd Font
TEMP_FONT="$(mktemp)" &&
wget -O "$TEMP_FONT" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip" &&
sudo unzip "$TEMP_FONT" -d /usr/share/fonts/truetype
rm -f "$TEMP_FONT"
fc-cache -f -v
fc-list | grep "Hack"

# Slack Install
slack_file="$(wget -q "https://slack.com/downloads/instructions/ubuntu" -O - \
| tr "\t\r\n'" '   "' \
| grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' \
| sed -e 's/^.*"\([^"]\+\)".*$/\1/g' \
| grep 'slack-desktop')"
install_deb_from_url "$slack_file"

# Chrome Install
install_deb_from_url "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

# NVM
NVM_VERSION=$(github_release nvm-sh/nvm)
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# Docker
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
sudo dpkg --purge docker docker-engine docker.io containerd runc
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(grep DISTRIB_CODENAME= /etc/upstream-release/lsb-release | awk -F = '{print $(2)}') stable"
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# Docker Compose
COMPOSE_VERSION=$(github_release docker/compose)
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y --no-install-recommends yarn

git lfs install

CHRUBY_VERSION=`git ls-remote https://github.com/postmodern/chruby | grep refs/tags | grep -oE "[0-9]+\.[0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
wget -qO- "https://github.com/postmodern/chruby/archive/v${CHRUBY_VERSION}.tar.gz" | tar xz -C "/tmp/"
cd "/tmp/chruby-${CHRUBY_VERSION}/"
sudo make install
cd -
rm -rf "/tmp/chruby-${CHRUBY_VERSION}/"

RUBY_INSTALL_VERSION=`git ls-remote https://github.com/postmodern/ruby-install | grep refs/tags | grep -oE "[0-9]+\.[0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
wget -qO- "https://github.com/postmodern/ruby-install/archive/v${RUBY_INSTALL_VERSION}.tar.gz" |  tar xz -C "/tmp/"
cd "/tmp/ruby-install-${RUBY_INSTALL_VERSION}/"
sudo make install
cd -
rm -rf "/tmp/ruby-install-${RUBY_INSTALL_VERSION}/"

ruby-install ruby 2.6.5
ruby-install --latest ruby

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
cd /tmp/
unzip awscliv2.zip
rm awscliv2.zip
sudo ./aws/install
cd -
rm -rf /tmp/aws

# VS Code Install
install_deb_from_url "https://update.code.visualstudio.com/latest/linux-deb-x64/stable" &&

rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig

sudo ln -s ~/.dotfiles/gpg.conf $GNUPGHOME/gpg.conf

# Set terminal config
dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ < terminal-profile
