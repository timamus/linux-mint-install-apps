# linux-mint-install-apps
Installing Apps in Linux Mint

## Quick start

- `sudo apt update && sudo apt install -y git`
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

## Install firefox developer edition

```
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
```
