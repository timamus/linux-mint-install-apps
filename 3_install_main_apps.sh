#!/usr/bin/env bash

set -Eeuo pipefail

# Installing veracrypt
echo -en "\033[1;33m Installing veracrypt... \033[0m \n"
sudo add-apt-repository ppa:unit193/encryption
sudo apt update && sudo apt -y install veracrypt

# Installing virtualbox
echo -en "\033[1;33m Installing virtualbox... \033[0m \n"
sudo apt -y install virtualbox virtualbox-ext-pack
sudo gpasswd -a $USER vboxusers

# Installing remmina with rdp and vnc plugins
echo -en "\033[1;33m Installing remmina with rdp and vnc plugins... \033[0m \n"
sudo apt -y install remmina remmina-plugin-rdp remmina-plugin-secret

# Installing gimp with help
echo -en "\033[1;33m Installing gimp with help... \033[0m \n"
sudo apt -y install gimp gimp-help-en

# Installing krita
echo -en "\033[1;33m Installing krita... \033[0m \n"
sudo apt -y install krita

# Installing inkscape
echo -en "\033[1;33m Installing inkscape... \033[0m \n"
sudo apt -y install inkscape

# Installing shotcut
echo -en "\033[1;33m Installing shotcut... \033[0m \n"
sudo apt -y install shotcut

# Installing smplayer with skins and themes
echo -en "\033[1;33m Installing smplayer with skins and themes... \033[0m \n"
sudo apt -y install smplayer smplayer-themes
smplayer -delete-config
smplayer &
echo "Waiting for 5 seconds for smplayer to open..."
sleep 5s
smplayer -send-action close
echo "Waiting for 5 seconds for smplayer to close..."
sleep 5s
sed -i 's/^\(gui\s*=\s*\).*$/\1MiniGUI/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(iconset\s*=\s*\).*$/\1PapirusDark/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(qt_style\s*=\s*\).*$/\1kvantum-dark/' $HOME/.config/smplayer/smplayer.ini

# Installing firefox
curl --location "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=ru" | tar --extract --verbose --preserve-permissions --bzip2
sudo mv firefox /opt/firefox-dev
touch ~/.local/share/application/firefox-dev.desktop

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
