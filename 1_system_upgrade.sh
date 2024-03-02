#!/usr/bin/env bash

set -Eeuo pipefail

# Update mirror list and set fastest download server
echo -en "\033[1;33m Update mirror list and set fastest download server... \033[0m \n"
sudo mintsources

# Start by updating and upgrading all packages installed in the system
echo -en "\033[1;33m Start by updating and upgrading all packages installed in the system... \033[0m \n"
sudo apt update && sudo apt upgrade -y

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
