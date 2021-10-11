#!/bin/bash

set -eo pipefail

# docker
echo '=== Installing Docker ===';
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
echo '=== Installing Docker-Compose ===';

# look for latest release
# https://github.com/docker/compose/tags

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0-rc3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# troubleshooting
# if docker-compose command fails, try with symlink
# sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose