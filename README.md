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

## Installing Linux Mint

Recommendations for installing Linux Mint:

- Check the encrypt home folder box

## Setting up the Timeshift

In the schedule tab, select the snapshot levels - month, and the number - 5. Other settings, leave by default.

## Vivaldi Options

Settings:

- Themes --> Manjaro-Cinnamon
- Tabs --> Enable Horizontal Scrolling
- Privacy and Security --> Notifications --> Block

Addons:

- https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb

## Firefox Options

Addons:

- https://addons.mozilla.org/ru/firefox/addon/ublock-origin/
- https://addons.mozilla.org/ru/firefox/addon/bitwarden-password-manager/
- https://addons.mozilla.org/ru/firefox/addon/new-tab-suspender/
- https://addons.mozilla.org/ru/firefox/addon/musicpro/

## Yandex.Disk

To configure Yandex.Disk, use the command: `yandex-disk setup`. If you plan to backup the Yandex.Disk folder via rsync, it is better not to use a dot in the folder name.

### Applets

> Battery Applet with Monitoring and Shutdown (BAMS)

Install the BAMS applet, then run:

```bash
mkdir $HOME/batterymonitor@pdcurtis && 
cp $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/stylesheet.css $HOME/batterymonitor@pdcurtis && 
sed -i -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/' -e '0,/red/s//rgba(0,0,0,0)/' $HOME/batterymonitor@pdcurtis/stylesheet.css
```

or to fix the BAMS applet settings directly, use the command below, but you will have to do this when the applet is updated

```bash
sed -i -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/' -e '0,/red/s//rgba(0,0,0,0)/' $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/3.2/stylesheet.css
```

Install dependencies: `sudo apt-get install -y zenity sox libsox-fmt-mp3`

Then, in the applet settings, select the option "Compact - Battery Percentage without extended messages" in the "Display Mode" area.

> ScreenShot+RecordDesktop

Install dependencies: `sudo apt install -y ffmpeg xdotool x11-utils`

> inhibit@cinnamon.org

### Desklets

> diskspace@schorschii

### Desktop wallpapers

- https://wallpaperaccess.com/manjaro
- https://www.reddit.com/r/wallpaper/
- https://www.reddit.com/r/wallpaper/comments/sox44n/chill_vibes_3440_1440/
- https://www.reddit.com/r/wallpaper/comments/sp0j3j/mountain_view_5120x2880/
- https://gitlab.com/tromsite/tromjaro/iso-profiles/-/tree/master/tromjaro/xfce/live-overlay/usr/share/backgrounds

### Favorite apps

You can change your favorite applications in System Settings --> Favorite applications:

- Music : mpv --> SMPlayer
- Video : mpv --> SMPlayer
- Photo : Pix --> Xviewer

## Other resources

- `git clone https://gitgud.io/hovereagle/manjaro_install_nonfree_components.git`
- Go to https://3.jetbra.in/ or to https://jetbra.in/s click on any available hostname and follow the instructions

## Installing LaTex and using it in VS Code

To install LaTex, run the command: `sudo apt install -y texlive-full latexmk`

1) If VS Code was not installed using this script, then open VS Code and install the latex-workshop extension.

2) Now open any .tex file and press Ctrl+Alt+b to build (or use VSCode Command Palette to run command LaTeX Workshop: Build with Recipe). From the options that pop up, select latexmk recipe.

3) Press Ctrl+Alt+v to view generated PDF file (select the Preview Inside VSCode option to open it side-by-side with the editor). Edit the .tex file to see changes reflected in PDF in real time.

## Install telegram not from flatpak

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
