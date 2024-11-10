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

# Deleting old dotnet versions
echo -en "\033[1;33m Deleting old dotnet versions... \033[0m \n"
rm -rf ~/.dotnet
rm -rf ~/.nuget
rm -rf ~/.local/share/NuGet
sed -i '/DOTNET_ROOT/d' ~/.bashrc
source ~/.bashrc
# Installing dotnet
echo -en "\033[1;33m Installing dotnet... \033[0m \n"
echo -en "\033[1;33m To install a different version, replace the version number in the script. For example, use 7.0 for .NET 7, 8.0 for .NET 8, etc. \033[0m \n"
wget 'https://dot.net/v1/dotnet-install.sh'
chmod +x ./dotnet-install.sh
./dotnet-install.sh -c 8.0
./dotnet-install.sh -c 8.0 --runtime aspnetcore
rm dotnet-install.sh
# Set environment variables and export them
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
# Add the new environment variables to ~/.bashrc for future use
echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc
source ~/.bashrc
# Installing some .NET CLI tools
echo -en "\033[1;33m Installing some of the .NET CLI tools... \033[0m \n"
dotnet tool install -g dotnet-grpc

# Installing jetbrains-toolbox
echo -en "\033[1;33m Installing jetbrains-toolbox... \033[0m \n"
function getLatestUrl() {
USER_AGENT=('User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36')
URL=$(curl 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' -H 'Origin: https://www.jetbrains.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.8' -H "${USER_AGENT[@]}" -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Referer: https://www.jetbrains.com/toolbox/download/' -H 'Connection: keep-alive' -H 'DNT: 1' --compressed | grep -Po '"linux":.*?[^\\]",' | awk -F ':' '{print $3,":"$4}'| sed 's/[", ]//g')
echo $URL
}
getLatestUrl
FILE=$(basename ${URL})
DEST=$PWD/$FILE
# Download and unpack jetbrains-toolbox
wget -cO  ${DEST} ${URL} --read-timeout=5 --tries=0
DIR="/opt/jetbrains-toolbox"
if sudo mkdir -p ${DIR}; then
    sudo tar -xzf ${DEST} -C ${DIR} --strip-components=1
fi
sudo chmod -R +rwx ${DIR}
# Creating a symbolic link to launch an application from the terminal with the command "jetbrains-toolbox"
sudo ln -s ${DIR}/jetbrains-toolbox /usr/local/bin/jetbrains-toolbox
sudo chmod -R +rwx /usr/local/bin/jetbrains-toolbox
# Deleting the jetbrains-toolbox installation files
rm ${DEST}
# Adding the jetbrains hostname to the host file
sudo sed -i '/1.2.3.4 account.jetbrains.com/d' /etc/hosts
sudo bash -c "echo 1.2.3.4 account.jetbrains.com >> /etc/hosts"
# Launching jetbrains-toolbox to create a desktop launcher
jetbrains-toolbox

# Installing dbeaver with plugins
echo -en "\033[1;33m Installing dbeaver with plugins... \033[0m \n"
sudo add-apt-repository ppa:serge-rider/dbeaver-ce -y
sudo apt update && sudo apt-get install -y dbeaver-ce

# Installing postman
echo -en "\033[1;33m Installing postman from flatpak... \033[0m \n"
flatpak install flathub com.getpostman.Postman -y
# sudo flatpak override com.getpostman.Postman --filesystem=host
# Applying a dark theme to postman
# To select the gtk theme to install: flatpak install mint-y-dark
flatpak install flathub org.gtk.Gtk3theme.Mint-Y-Dark -y
flatpak override com.getpostman.Postman --user --env=GTK_THEME=Mint-Y-Dark
flatpak override com.getpostman.Postman --user --env=GTK_STYLE_OVERRIDE=Mint-Y-Dark

echo -en "\033[0;35m Installation successfull \033[0m \n"
echo 'A system reboot is recommended. Reboot? (y/n)' && read x && [[ "$x" == "y" ]] && /sbin/reboot;
