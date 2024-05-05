#!/usr/bin/env bash

set -Eeuo pipefail

# Creating a swap file with automatic determination of its size for hibernation
echo -en "\033[1;33m Creating a swap file with automatic determination of its size for hibernation... \033[0m \n"
echo -en "\033[1;33m Check if there is a swapfile by default... \033[0m \n"
if [[ $(swapon -s | grep "/swapfile") ]]; then # Check if the swapfile exists, if so, then delete it
  echo -en "\033[1;33m Yes, the swap file exists! Deleting it... \033[0m \n"
  sudo swapoff /swapfile
  sudo sed -i '/[Ss]wap/d' /etc/fstab
  sudo mount -a
  sudo systemctl daemon-reload
  [[ -f /swapfile ]] && sudo rm -rf /swapfile
  [[ -f /etc/default/grub.d/resume.cfg ]] && sudo rm -rf /etc/default/grub.d/resume.cfg
  sudo sed -i 's@HibernateDelaySec=60min@#HibernateDelaySec=180min@g' /etc/systemd/sleep.conf
  sudo update-grub
fi
# Calculate required swap size
TOTAL_MEMORY_G=$(awk '/MemTotal/ { print ($2 / 1048576) }' /proc/meminfo)
TOTAL_MEMORY_ROUND=$(echo "$TOTAL_MEMORY_G" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
TOTAL_MEMORY_SQRT=$(echo "$TOTAL_MEMORY_G" | awk '{print sqrt($1)}')
ADD_SWAP_SIZE=$(echo "$TOTAL_MEMORY_SQRT" | awk '{print ($0-int($0)<0.499)?int($0):int($0)+1}')
# A block size of 1 mebibyte is better, in case of a small amount of RAM, the dd process will not be killed by oomkiller
SWAP_SIZE_WITH_HYBER_M=$((($TOTAL_MEMORY_ROUND + $ADD_SWAP_SIZE) * 1024))
ROOT_PATH=$(df / | sed -n '2 p' | awk '{print $1;}')
if [[ -z "$(swapon -s)" ]]; then # Check if there is any swap (partition or file), if not, then create it
  if [[ $(lsblk -no FSTYPE $ROOT_PATH) == "ext4" ]]; then # Configure swap for ext4 with hibernate support
    sudo dd if=/dev/zero of=/swapfile bs=1M count=$SWAP_SIZE_WITH_HYBER_M status=progress
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo bash -c "echo -e '# Swapfile for hibernation support\n/swapfile none swap defaults 0 0' >> /etc/fstab"
    SWAP_DEVICE=$(findmnt -no UUID -T /swapfile)
    SWAP_FILE_OFFSET=$(sudo filefrag -v /swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')
    sudo mkdir -p /etc/default/grub.d/
    sudo bash -c "echo -e '# Added by a script\nGRUB_CMDLINE_LINUX_DEFAULT=\"\$GRUB_CMDLINE_LINUX_DEFAULT resume=UUID=$SWAP_DEVICE resume_offset=$SWAP_FILE_OFFSET\"' > /etc/default/grub.d/resume.cfg"
    sudo update-grub
    sudo sed -i 's@#HibernateDelaySec=180min@HibernateDelaySec=60min@g' /etc/systemd/sleep.conf 
    # Adding Hibernate to the shutdown dialog
    sudo tee /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla <<'EOB'
[Enable hibernate]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate;org.freedesktop.login1.handle-hibernate-key;org.freedesktop.login1;org.freedesktop.login1.hibernate-multiple-sessions
ResultActive=yes
EOB
  fi
else
  echo -en "\033[0;31m Cancelled! Swap already exists... \033[0m \n"
fi

# Start and enable ufw
echo -en "\033[1;33m Start and enable ufw... \033[0m \n"
sudo systemctl start ufw
sudo systemctl enable ufw
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw enable

# Configuring gnome-system-monitor
# https://unix.stackexchange.com/questions/174683/custom-global-keybindings-in-cinnamon-via-gsettings
echo -en "\033[1;33m Configuring gnome-system-monitor... \033[0m \n"
gsettings set org.cinnamon.desktop.keybindings custom-list \ "['custom0']"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ name "System monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ command "gnome-system-monitor"
gsettings set org.cinnamon.desktop.keybindings.custom-keybinding:/org/cinnamon/desktop/keybindings/custom-keybindings/custom0/ binding "['<Primary><Shift><Ctrl>Escape']"

# Changing the keyboard layout with hotkey
# if [ $(locale | sed -n 's/^LANG=//p') == "ru_RU.UTF-8" ]; then
#  gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']"
# fi
echo -en "\033[1;33m Changing the keyboard layout with hotkey... \033[0m \n"
echo "Do you wish to add Russian layout? Enter 1 or 2"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) gsettings set org.gnome.libgnomekbd.keyboard layouts "['us', 'ru']"; break;;
    No ) exit;;
  esac
done
gsettings set org.gnome.libgnomekbd.keyboard options "['grp\tgrp:alt_shift_toggle']"
gsettings set org.cinnamon.desktop.interface keyboard-layout-show-flags false
gsettings set org.cinnamon.desktop.interface keyboard-layout-use-upper true

# Changing some Cinnamon settings (screen saver, sound, background, privacy)
echo -en "\033[1;33m Changing some Cinnamon settings (screen saver, sound, background)... \033[0m \n"
# The delay before starting the screensaver is 5 minutes
gsettings set org.cinnamon.desktop.session idle-delay 300
# Delay before screensaver is blocked
gsettings set org.cinnamon.desktop.screensaver lock-delay 15
# Setting the sound volume to 150%
gsettings set org.cinnamon.desktop.sound maximum-volume 150
# Background image format
gsettings set org.cinnamon.desktop.background picture-options 'stretched'
# Appearance (for Linux Mint 21.2 and above)
gsettings set org.x.apps.portal color-scheme 'prefer-dark'
# Gtk theme
gsettings set org.cinnamon.desktop.interface gtk-theme 'Mint-Y-Dark-Orange'
# Icon theme (Mint-Y-Yaru for Linux Mint 21.2 and above)
if [ -d "/usr/share/icons/Mint-Y-Yaru" ] || [ -d "$HOME/.icons/Mint-Y-Yaru" ]; then
  gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-Y-Yaru'
else
  gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-Y-Orange'
fi
# Menu theme
gsettings set org.cinnamon.theme name 'Mint-Y-Dark-Orange'
# In the right menu bar, reduce the size of the color icon to 16 px from 24px
gsettings set org.cinnamon panel-zone-icon-sizes '[{"panelId": 1, "left": 0, "center": 0, "right": 16}]'
# Disable the "Recent Files" feature in the Cinnamon desktop environment
gsettings set org.cinnamon.desktop.privacy remember-recent-files false
# Turn on the display of the "Computer" icon on the desktop
gsettings set org.nemo.desktop computer-icon-visible true
# Turn on the display of the "Trash" icon on the desktop
gsettings set org.nemo.desktop trash-icon-visible true
# Power management settings
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-ac 900
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800
gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-ac-action 'suspend'
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-battery 1800
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-inactive-battery-timeout 2700
gsettings set org.cinnamon.settings-daemon.plugins.power lid-close-battery-action 'suspend'

# Check if timeshift is installed in the system
echo -en "\033[1;33m Check whether timeshift is installed to configure it... \033[0m \n"
if which timeshift &> /dev/null ; then
  # Setting up timeshift
  echo -en "\033[1;33m Configure timeshift for your PC. After setting up, close timeshift and the configuration script will continue... \033[0m \n"
  sudo timeshift-launcher
else
  echo -en "\033[0;31m Cancelled! The timeshift program was not installed... \033[0m \n"
fi

# Installing recommended drivers
echo -en "\033[1;33m Install the recommended drivers. After installation, close the Driver Manager and reboot system... \033[0m \n"
mintdrivers

echo -en "\033[0;35m System settings are completed \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
