#!/bin/bash

# install packages
echo '=== Installing Packages ===';
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# sys update
echo '=== System Update ===';
sudo apt-get \
    update \
    dist-upgrade \
    autoremove \
    clean

# add new repos
echo '=== Add new Repositorys ===';
sudo add-apt-repository \
    ppa:philip.scott/elementary-tweaks \
    ppa:git-core/ppa \
    ppa:pinta-maintainers/pinta-stable

sudo apt-get update

# install apps
echo '=== Installing Apps ===';
sudo apt install \
    elementary-tweaks \
    git \
    pinta \
    chromium-browser \
    vlc

# docker
echo '=== Installing Apps [Docker] ===';
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt-get update
sudo apt-get install docker-ce

### troubleshooting ###
# if you dont want to enter sudo password every time, add docker to root group
# sudo usermod -aG docker ${USER}
# su - ${USER}
# check
# id -nG

# docker-compose
echo '=== Installing Apps [Docker-Compose] ===';

# look for latest release
# https://github.com/docker/compose/tags

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0-rc3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# troubleshooting
# if docker-compose command fails, try with symlink
# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


# install atom
echo '=== Installing Apps [Atom] ===';
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
sudo apt-get update
sudo apt-get install atom


# phpstorm
# download tar.gz file
# https://www.jetbrains.com/phpstorm/
# tar xvf PhpStorm-2019.3.4.tar.gz
# sudo mv PhpStorm-193.6911.26 /usr/local/bin

# postman
# download tar.gz file
# https://www.postman.com/downloads/
# tar xvf Postman-linux-x64-7.21.1.tar.gz
# sudo mv Postman /usr/local/bin
