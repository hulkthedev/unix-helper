#!/bin/bash

set -eo pipefail

echo '=== Update System ===';
sudo apt-get \
    update \
    dist-upgrade \
    autoremove \
    clean