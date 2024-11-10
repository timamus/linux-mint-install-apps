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
# echo -en "\033[1;33m Installing remmina with rdp and vnc plugins... \033[0m \n"
# sudo apt install -y remmina remmina-plugin-rdp remmina-plugin-secret
echo -en "\033[1;33m Installing remmina from flatpak... \033[0m \n"
flatpak install flathub org.remmina.Remmina -y

# Installing gimp with help
# echo -en "\033[1;33m Installing gimp with help... \033[0m \n"
# sudo apt install -y gimp gimp-help-en
echo -en "\033[1;33m Installing gimp from flatpak... \033[0m \n"
flatpak install flathub org.gimp.GIMP -y

# Installing krita
# echo -en "\033[1;33m Installing krita... \033[0m \n"
# sudo apt install -y krita
echo -en "\033[1;33m Installing krita from flatpak... \033[0m \n"
flatpak install flathub org.kde.krita -y

# Installing inkscape
# echo -en "\033[1;33m Installing inkscape... \033[0m \n"
# sudo apt install -y inkscape inkscape-open-symbols
echo -en "\033[1;33m Installing inkscape from flatpak... \033[0m \n"
flatpak install flathub org.inkscape.Inkscape -y
sudo apt install -y inkscape-open-symbols

# Installing shotcut
# echo -en "\033[1;33m Installing shotcut... \033[0m \n"
# sudo apt install -y shotcut
echo -en "\033[1;33m Installing shotcut from flatpak... \033[0m \n"
flatpak install flathub org.shotcut.Shotcut -y

# Installing mpv to support two subtitles in smplayer
echo -en "\033[1;33m Installing mpv... \033[0m \n"
sudo apt install -y mpv

# Installing smplayer with themes
echo -en "\033[1;33m Installing smplayer with themes... \033[0m \n"
sudo add-apt-repository ppa:rvm/smplayer -y
sudo apt update && sudo apt install -y smplayer smplayer-themes qt5-style-kvantum
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
# echo -en "\033[1;33m Installing vivaldi... \033[0m \n"
# wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add -
# sudo add-apt-repository 'deb https://repo.vivaldi.com/archive/deb/ stable main' -y
# sudo apt update && sudo apt install -y vivaldi-stable
echo -en "\033[1;33m Installing vivaldi from flatpak... \033[0m \n"
flatpak install flathub com.vivaldi.Vivaldi -y

# Installing telegram
echo -en "\033[1;33m Installing telegram from flatpak... \033[0m \n"
flatpak install flathub org.telegram.desktop -y
flatpak override org.telegram.desktop --user --filesystem=home

# Installing bitwarden
echo -en "\033[1;33m Installing bitwarden from flatpak... \033[0m \n"
flatpak install flathub com.bitwarden.desktop -y
flatpak override com.bitwarden.desktop --user --filesystem=home
# Applying a dark theme to bitwarden
# To select the gtk theme to install: flatpak install mint-y-dark
flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark -y
flatpak override com.bitwarden.desktop --user --env=GTK_THEME=Mint-Y-Dark
flatpak override com.bitwarden.desktop --user --env=GTK_STYLE_OVERRIDE=Mint-Y-Dark

# Installing goldendict
echo -en "\033[1;33m Installing goldendict... \033[0m \n"
sudo apt install -y goldendict

# Installing calibre
# echo -en "\033[1;33m Installing calibre... \033[0m \n"
# sudo apt install -y calibre
echo -en "\033[1;33m Installing calibre from flatpak... \033[0m \n"
flatpak install flathub com.calibre_ebook.calibre -y

# Installing bleachbit
echo -en "\033[1;33m Installing bleachbit... \033[0m \n"
sudo apt install -y bleachbit

# Installing obsidian
echo -en "\033[1;33m Installing obsidian from flatpak... \033[0m \n"
flatpak install flathub md.obsidian.Obsidian -y
flatpak override md.obsidian.Obsidian --user --filesystem=home

# Installing MS Core fonts
echo -en "\033[1;33m Installing MS Core fonts... \033[0m \n"
sudo apt install -y ttf-mscorefonts-installer

# Installing ProtonVPN
# echo -en "\033[1;33m Installing ProtonVPN... \033[0m \n"
# wget -q -O - https://repo.protonvpn.com/debian/public_key.asc | sudo apt-key add -
# sudo add-apt-repository 'deb https://repo.protonvpn.com/debian stable main'
# sudo apt update && sudo apt install -y protonvpn
echo -en "\033[1;33m Installing ProtonVPN from flatpak... \033[0m \n"
flatpak install flathub com.protonvpn.www -y

# Installing luckybackup
# echo -en "\033[1;33m Installing luckybackup... \033[0m \n"
# sudo apt install -y luckybackup

# Installing grsync
echo -en "\033[1;33m Installing grsync... \033[0m \n"
sudo apt install -y grsync

# Installing tor-browser
# echo -en "\033[1;33m Installing tor-browser... \033[0m \n"
# URL='https://tor.eff.org/download/' # Official mirror https://www.torproject.org/download/, may be blocked
# LINK=$(wget -qO- $URL | grep -oP -m 1 'href="\K/dist.+?tar.xz' || true) # https://stackoverflow.com/questions/75081074/the-script-sometimes-doesnt-run-after-wget
# URL='https://tor.eff.org'${LINK}
# curl --location $URL | tar xJ --extract --verbose --preserve-permissions
# sudo rm -rf /opt/tor-browser
# sudo mv tor-browser /opt
# sudo chown -R $USER /opt/tor-browser
# cd /opt/tor-browser
# ./start-tor-browser.desktop --register-app

# Installing tor-browser-launcher
echo -en "\033[1;33m Installing tor-browser-launcher from flatpak... \033[0m \n"
flatpak install flathub org.torproject.torbrowser-launcher -y

# Installing steam
# You can enable Proton in the Steam Client in Steam > Settings > Steam Play
# echo -en "\033[1;33m Installing steam... \033[0m \n"
# sudo apt install -y steam
echo -en "\033[1;33m Installing steam from flatpak... \033[0m \n"
flatpak install flathub com.valvesoftware.Steam -y

# Installing redshift
echo -en "\033[1;33m Installing redshift... \033[0m \n"
sudo apt install -y redshift redshift-gtk

# Installing unrar
echo -en "\033[1;33m Installing unrar... \033[0m \n"
sudo apt install -y unrar

# Installing flatseal
echo -en "\033[1;33m Installing flatseal from flatpak... \033[0m \n"
flatpak install flathub com.github.tchx84.Flatseal -y

# Installing visual studio code
echo -en "\033[1;33m Installing visual studio code... \033[0m \n"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code # or code-insiders

# Installing some extensions for visual studio code
code --install-extension James-Yu.latex-workshop

# Installing and removing language packs
echo -en "\033[1;33m Install the language packs by clicking on the 'Install / Remove Languages...' button \033[0m \n"
mintlocale

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
