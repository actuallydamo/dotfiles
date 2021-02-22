#!/bin/bash

# Prerequisites
sudo apt update && sudo apt install -y libmysqlclient-dev libpq-dev wkhtmltopdf redis-tools make cmake git ruby-dev pv

# Chrome Install
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# NVM
NVM_VERSION=`git ls-remote https://github.com/nvm-sh/nvm | grep refs/tags | grep -oE "v[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# Docker
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
sudo dpkg --purge docker docker-engine docker.io containerd runc
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(grep DISTRIB_CODENAME= /etc/upstream-release/lsb-release | awk -F = '{print $(2)}') stable"
sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io

# Docker Rootless
sudo apt install -y uidmap
curl -fsSL https://get.docker.com/rootless | sh
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
systemctl --user start docker
systemctl --user enable docker
sudo loginctl enable-linger $(whoami)

# Docker Compose
COMPOSE_VERSION=`git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oE "[0-9]+\.[0-9][0-9]+\.[0-9]+$" | sort --version-sort | tail -n 1`
sudo curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y --no-install-recommends yarn

git lfs install

rm ~/.gitconfig
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
