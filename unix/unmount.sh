#!/bin/bash

set -eo pipefail

# unmount windows devices
umount /dev/sda1
umount /dev/sdb1
umount /dev/sdc1
umount /dev/nvme0n1p2
umount /dev/nvme0n1p1
