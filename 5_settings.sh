#!/usr/bin/env bash

set -Eeuo pipefail

# Creating a swap file with automatic determination of its size for hibernation
echo -en "\033[1;33m Creating a swap file with automatic determination of its size for hibernation... \033[0m \n"
echo -en "\033[1;33m Check if there is a swapfile by default... \033[0m \n"
if [[ $(swapon -s | grep "/swapfile") ]]; then # Check if the swapfile exists, if so, then delete it
  echo -en "\033[1;33m Yes, the swap file exists! Deleting it... \033[0m \n"
  sudo swapoff /swapfile && 
  sudo sed -i '/[Ss]wap/d' /etc/fstab && 
  sudo mount -a && 
  sudo systemctl daemon-reload && 
  [[ -f /swapfile ]] && sudo rm -rf /swapfile 
  [[ -f /etc/default/grub.d/resume.cfg ]] && sudo rm -rf /etc/default/grub.d/resume.cfg 
  sudo sed -i '/grub.d/d' /etc/default/grub && 
  sudo sed -i 's@HibernateDelaySec=60min@#HibernateDelaySec=180min@g' /etc/systemd/sleep.conf && 
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
#    if [[ -z $(grep "source /etc/default/grub.d/*" /etc/default/grub) ]]
#      then
#        sudo bash -c "echo -e '\n\nsource /etc/default/grub.d/resume.cfg' >> /etc/default/grub"
#    fi
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

echo -en "\033[0;35m System settings are completed \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
