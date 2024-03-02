#!/usr/bin/env bash

# ------------------------------------------------------------------
# Script Name:  power_management.sh
# Description:  This script allows the user to select between different
#               power management settings. It's especially useful for
#               situations where you don't want automatic actions to be
#               interrupted, like continuous mouse movement over RDP.
# Usage:        ./power_management.sh
# ------------------------------------------------------------------

# Make the script more robust
set -Eeuo pipefail

# Display menu for user selection with colored text
echo -en "\033[1;34mChoose a power management mode:\033[0m \n"
echo -en "\033[1;32m1) Default power management settings\033[0m \n"
echo -en "\033[1;32m2) Full Power and Ignore Lid Close\033[0m \n"

# Read user choice
read -p "Your choice (1/2): " choice

# Apply the selected mode
case $choice in
    1)
        echo -en "\033[1;33mApplying default power management settings...\033[0m \n"
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-ac 900
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800
        gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-ac-action 'suspend'
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-battery 1800
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-battery-timeout 2700
        gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-battery-action 'suspend'
        sudo sed -i '/IgnoreLid=/{s/true/false/}' /etc/UPower/UPower.conf
        sudo systemctl restart upower
        sudo sed -i 's/HandleLidSwitch=/#HandleLidSwitch=/g' /etc/systemd/logind.conf
        sudo sed -i 's/HandleLidSwitchDocked=/#HandleLidSwitchDocked=/g' /etc/systemd/logind.conf
        sudo sed -i 's/LidSwitchIgnoreInhibited=/#LidSwitchIgnoreInhibited=/g' /etc/systemd/logind.conf
        sudo systemctl restart systemd-logind
        ;;
    2)
        echo -en "\033[1;33mApplying full power and ignoring lid close...\033[0m \n"
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-ac 0
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
        gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-ac-action 'nothing'
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-battery 0
        gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
        gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-battery-action 'nothing'
        sudo sed -i '/IgnoreLid=/{s/false/true/}' /etc/UPower/UPower.conf
        sudo systemctl restart upower
        sudo sed -i 's/#HandleLidSwitch=/HandleLidSwitch=/g' /etc/systemd/logind.conf
        sudo sed -i 's/#HandleLidSwitchDocked=/HandleLidSwitchDocked=/g' /etc/systemd/logind.conf
        sudo sed -i 's/#LidSwitchIgnoreInhibited=/LidSwitchIgnoreInhibited=/g' /etc/systemd/logind.conf
        sudo systemctl restart systemd-logind
        ;;
    *)
        echo -en "\033[1;31mInvalid choice. Exiting.\033[0m \n"
        exit 1
        ;;
esac

echo -en "\033[1;34mSettings applied.\033[0m \n"
