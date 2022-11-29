#!/usr/bin/env bash

set -Eeuo pipefail

# Installing veracrypt
echo -en "\033[1;33m Installing veracrypt... \033[0m \n"
sudo add-apt-repository ppa:unit193/encryption
sudo apt update && sudo apt install veracrypt

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
