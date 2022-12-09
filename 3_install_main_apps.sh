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

# Installing firefox-developer-edition
echo -en "\033[1;33m Installing firefox-developer-edition... \033[0m \n"
curl --location "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=ru" | tar --extract --verbose --preserve-permissions --bzip2
sudo mv firefox /opt/firefox-dev
sudo chown -R $USER /opt/firefox-dev
# Creating a symbolic link to launch an application from the terminal with the command "firefox-dev"
sudo ln -s /opt/firefox-dev/firefox /usr/local/bin/firefox-dev
# Creating a desktop launcher
cat << EOF > ~/.local/share/applications/firefox-dev.desktop
[Desktop Entry]
Name=Firefox Developer Edition
GenericName=Web Browser
Exec=firefox-dev %u
Icon=/opt/firefox-dev/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;
Keywords=web;browser;internet;
Actions=new-window;new-private-window;
StartupWMClass=Firefox Developer Edition

[Desktop Action new-window]
Name=Open a New Window
Exec=firefox-dev %u

[Desktop Action new-private-window]
Name=Open a New Private Window
Exec=firefox-dev --private-window %u
EOF

# Installing vivaldi
echo -en "\033[1;33m Installing vivaldi... \033[0m \n"
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main'
sudo apt update && sudo apt install vivaldi-stable

# Installing telegram
echo -en "\033[1;33m Installing telegram from flatpak... \033[0m \n"
flatpak install flathub org.telegram.desktop -y
sudo flatpak override org.telegram.desktop --filesystem=host

# Installing bitwarden
echo -en "\033[1;33m Installing bitwarden from flatpak... \033[0m \n"
flatpak install flathub com.bitwarden.desktop -y
# Applying a dark theme to bitwarden
# To select the gtk theme to install: flatpak install mint-y-dark
flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark -y
sudo flatpak override com.bitwarden.desktop --env=GTK_STYLE_OVERRIDE=Mint-Y-Dark

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
