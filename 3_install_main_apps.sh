#!/usr/bin/env bash

set -Eeuo pipefail

# Installing veracrypt
echo -en "\033[1;33m Installing veracrypt... \033[0m \n"
sudo add-apt-repository ppa:unit193/encryption -y
sudo apt update && sudo apt -y install veracrypt

# Installing virtualbox
echo -en "\033[1;33m Installing virtualbox... \033[0m \n"
sudo apt install -y virtualbox virtualbox-ext-pack
sudo gpasswd -a $USER vboxusers

# Installing remmina with rdp and vnc plugins
echo -en "\033[1;33m Installing remmina with rdp and vnc plugins... \033[0m \n"
sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret

# Installing gimp with help
echo -en "\033[1;33m Installing gimp with help... \033[0m \n"
sudo apt install -y gimp gimp-help-en

# Installing krita
echo -en "\033[1;33m Installing krita... \033[0m \n"
sudo apt install -y krita

# Installing inkscape
echo -en "\033[1;33m Installing inkscape... \033[0m \n"
sudo apt install -y inkscape inkscape-open-symbols

# Installing shotcut
echo -en "\033[1;33m Installing shotcut... \033[0m \n"
sudo apt install -y shotcut

# Installing mpv to support two subtitles in smplayer
echo -en "\033[1;33m Installing mpv... \033[0m \n"
sudo apt install -y mpv

# Installing smplayer with skins and themes
echo -en "\033[1;33m Installing smplayer with skins and themes... \033[0m \n"
sudo add-apt-repository ppa:rvm/smplayer -y
sudo apt update && sudo apt install -y smplayer smplayer-themes smplayer-skins
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
# Using mpv instead of mplayer
sed -i 's#^\(mplayer_bin\s*=\s*\).*#$\1/usr/bin/mpv#' $HOME/.config/smplayer/smplayer.ini
# Max. amplification
sed -i 's/^\(softvol_max\s*=\s*\).*$/\1150/' $HOME/.config/smplayer/smplayer.ini
# Volume normalization
sed -i 's/^\(initial_volnorm\s*=\s*\).*$/\1true/' $HOME/.config/smplayer/smplayer.ini
# Do not save recent files
sed -i 's|^\(latest_dir=\).*|\1|' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(save_dirs=\).*$/\1false/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(recents\\max_items=\).*$/\10/' $HOME/.config/smplayer/smplayer.ini
sed -i 's/^\(urls\\max_items=\).*$/\10/' $HOME/.config/smplayer/smplayer.ini

# Installing vivaldi
echo -en "\033[1;33m Installing vivaldi... \033[0m \n"
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main' -y
sudo apt update && sudo apt install -y vivaldi-stable

# Installing telegram
echo -en "\033[1;33m Installing telegram from flatpak... \033[0m \n"
flatpak install flathub org.telegram.desktop -y
sudo flatpak override org.telegram.desktop --filesystem=host

# Installing bitwarden
echo -en "\033[1;33m Installing bitwarden from flatpak... \033[0m \n"
flatpak install flathub com.bitwarden.desktop -y
sudo flatpak override com.bitwarden.desktop --filesystem=host
# Applying a dark theme to bitwarden
# To select the gtk theme to install: flatpak install mint-y-dark
flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark -y
sudo flatpak override com.bitwarden.desktop --env=GTK_THEME=Mint-Y-Dark
sudo flatpak override com.bitwarden.desktop --env=GTK_STYLE_OVERRIDE=Mint-Y-Dark

# Installing goldendict
echo -en "\033[1;33m Installing goldendict... \033[0m \n"
sudo apt install -y goldendict

# Installing calibre
echo -en "\033[1;33m Installing calibre... \033[0m \n"
sudo apt install -y calibre

# Installing bleachbit
echo -en "\033[1;33m Installing bleachbit... \033[0m \n"
sudo apt install -y bleachbit

# Installing obsidian
echo -en "\033[1;33m Installing obsidian from flatpak... \033[0m \n"
flatpak install flathub md.obsidian.Obsidian -y
sudo flatpak override md.obsidian.Obsidian --filesystem=host

# Installing MS Core fonts
echo -en "\033[1;33m Installing MS Core fonts... \033[0m \n"
sudo apt install -y ttf-mscorefonts-installer

# Installing ProtonVPN
echo -en "\033[1;33m Installing ProtonVPN... \033[0m \n"
BASE_URL='https://repo.protonvpn.com/debian/dists/stable/main/binary-all/'
BINARY_FILE=$(wget -qO- $BASE_URL | grep -oP 'href="\Kprotonvpn-stable-release.+?deb' | head -n 1)
# Check if the binary file is not empty
if [[ -z "$BINARY_FILE" ]]; then
    echo "Error: Unable to find ProtonVPN .deb file."
    exit 1
fi
FULL_URL="${BASE_URL}${BINARY_FILE}"
wget -O "$BINARY_FILE" "$FULL_URL"
sudo dpkg -i "$BINARY_FILE"
rm -f "$BINARY_FILE"
sudo apt update && sudo apt install -y protonvpn

# Installing luckybackup
echo -en "\033[1;33m Installing luckybackup... \033[0m \n"
sudo apt install -y luckybackup

# Installing yandex-disk
echo -en "\033[1;33m Installing yandex-disk... \033[0m \n"
echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/yandex-disk.list > /dev/null
wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | sudo apt-key add -
sudo apt update && sudo apt install -y yandex-disk

# Installing yandex-disk-indicator
echo -en "\033[1;33m Installing yandex-disk-indicator... \033[0m \n"
# sudo add-apt-repository ppa:slytomcat/ppa -y
# sudo apt update && sudo apt install -y yd-tools
# Installing dependencies
sudo apt-get install -y gir1.2-appindicator3-0.1 xclip
# Defining the URL of the package directory
PACKAGE_URL="https://launchpad.net/~slytomcat/+archive/ubuntu/ppa/+files/"
# Defining the filename of the package
PACKAGE_NAME="yd-tools_1.11.0_all.deb"
# Downloading the package
wget "${PACKAGE_URL}${PACKAGE_NAME}" -O $PACKAGE_NAME
# Installing the package
sudo dpkg -i $PACKAGE_NAME
# Installing any missing dependencies
sudo apt-get install -f
# Preventing the package from being automatically upgraded
sudo apt-mark hold yd-tools
# Removing the package file to free up space (optional)
rm $PACKAGE_NAME

# Installing tor-browser
echo -en "\033[1;33m Installing tor-browser... \033[0m \n"
URL='https://tor.eff.org/download/' # Official mirror https://www.torproject.org/download/, may be blocked
LINK=$(wget -qO- $URL | grep -oP -m 1 'href="\K/dist.+?tar.xz' || true) # https://stackoverflow.com/questions/75081074/the-script-sometimes-doesnt-run-after-wget
URL='https://tor.eff.org'${LINK}
curl --location $URL | tar xJ --extract --verbose --preserve-permissions
sudo rm -rf /opt/tor-browser
sudo mv tor-browser /opt
sudo chown -R $USER /opt/tor-browser
cd /opt/tor-browser
./start-tor-browser.desktop --register-app

# Installing steam
# You can enable Proton in the Steam Client in Steam > Settings > Steam Play
echo -en "\033[1;33m Installing steam... \033[0m \n"
sudo apt install -y steam

# Installing unrar
echo -en "\033[1;33m Installing unrar... \033[0m \n"
sudo apt install -y unrar

# Installing and removing language packs
echo -en "\033[1;33m Install the language packs by clicking on the 'Install / Remove Languages...' button \033[0m \n"
mintlocale

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
