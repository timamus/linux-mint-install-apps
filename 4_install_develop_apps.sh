#!/usr/bin/env bash

set -Eeuo pipefail

# Installing nodejs & npm. Npm is needed for xamarin-android
echo -en "\033[1;33m Installing nodejs & npm... \033[0m \n"
sudo apt update && sudo apt install -y nodejs npm
npm config set prefix ~/.npm-packages
export PATH=$PATH:~/.npm-packages/bin
# Upgrade Node.js
sudo npm install n -g && sudo n stable # only this package install with sudo, because it update node version 

# Installing mono
echo -en "\033[1;33m Installing mono... \033[0m \n"
sudo apt install -y mono-complete

# Installing dotnet version
wget 'https://dot.net/v1/dotnet-install.sh'
chmod +x ./dotnet-install.sh
./dotnet-install.sh -c 6.0
./dotnet-install.sh -c 6.0 --runtime aspnetcore
echo 'export PATH=$PATH:/home/`whoami`/.dotnet' >> ~/.bashrc

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

# Installing dbeaver with plugins
echo -en "\033[1;33m Installing dbeaver with plugins... \033[0m \n"
sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt update && sudo apt-get install -y dbeaver-ce

# Installing postman
echo -en "\033[1;33m Installing postman from flatpak... \033[0m \n"
flatpak install flathub com.getpostman.Postman -y
sudo flatpak override com.getpostman.Postman --filesystem=host
sudo flatpak override com.getpostman.Postman --env=GTK_STYLE_OVERRIDE=Mint-Y-Dark

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
