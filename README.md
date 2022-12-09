# linux-mint-install-apps
Installing Apps in Linux Mint

## Quick start

- `sudo apt update && sudo apt install git`
- `git clone https://github.com/timamus/linux-mint-install-apps.git`
- `cd linux-mint-install-apps/`
- `find ./ -name "*.sh" -exec chmod +x {} \;`
- `./1_system_upgrade.sh`
- `./2_install_system_apps.sh`
- `./3_install_main_apps.sh`
- `./4_install_develop_apps.sh`
- `./5_settings.sh`

## Install telegram

```
# Installing telegram
echo -en "\033[1;33m Installing telegram... \033[0m \n"
curl --location "https://telegram.org/dl/desktop/linux" | tar xJ --extract --verbose --preserve-permissions
sudo mv Telegram /opt
sudo chown -R $USER /opt/Telegram
# Creating a symbolic link to launch an application from the terminal with the command "telegram-desktop"
sudo ln -s /opt/Telegram/Telegram /usr/local/bin/telegram-desktop
# Creating a desktop launcher
cat << EOF > ~/.local/share/applications/telegram.desktop
[Desktop Entry]
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
TryExec=telegram-desktop
Exec=telegram-desktop -- %u
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
Actions=Quit;
SingleMainWindow=true
X-GNOME-UsesNotifications=true
X-GNOME-SingleWindow=true
[Desktop Action Quit]
Exec=telegram-desktop -quit
Name=Quit Telegram
Icon=application-exit
EOF
```
