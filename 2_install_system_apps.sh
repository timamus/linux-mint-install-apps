#!/usr/bin/env bash

set -Eeuo pipefail

# Installing dconf-editor
echo -en "\033[1;33m Installing dconf-editor... \033[0m \n"
sudo apt install -y dconf-editor

# Installing pavucontrol
echo -en "\033[1;33m Installing pavucontrol... \033[0m \n"
sudo apt install -y pavucontrol

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
