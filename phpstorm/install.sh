#!/bin/bash

set -eo pipefail

# download tar.gz file
# https://www.jetbrains.com/phpstorm/

tar xvf PhpStorm-2019.3.4.tar.gz
sudo mv PhpStorm-193.6911.26 /usr/local/bin