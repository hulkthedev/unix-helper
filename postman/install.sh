#!/bin/bash

set -eo pipefail

# download tar.gz file
# https://www.postman.com/downloads/

tar xvf Postman-linux-x64-7.21.1.tar.gz
sudo mv Postman /usr/local/bin