#!/bin/bash

set -eo pipefail

echo '=== Preparing ===';
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

echo '=== Add new Repositories ===';
sudo add-apt-repository \
    ppa:philip.scott/elementary-tweaks \
    ppa:git-core/ppa \
    ppa:pinta-maintainers/pinta-stable

sudo apt-get update

echo '=== Installing Apps ===';
sudo apt install \
    elementary-tweaks \
    git \
    pinta \
    chromium-browser \
    vlc