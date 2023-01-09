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

## How to do manual partitioning

First, click on the "New Partition Table" button and click "Continue". 

My recommendation:

1. EFI PARTITION  
   Select the free space → Create partition  
   a. Size → input 300  
   b. Type for the new partition → select Primary  
   c. Location for the new partition → select Beginning of this space  
   d. Use as → select EFI System Partition  

2. BOOT PARTITION  
   Select the free space → Create partition  
   a. Size → input 768  
   b. Type for the new partition → select Primary  
   c. Location for the new partition → select Beginning of this space  
   d. Use as → select Ext4 journaling file system  
   e. Mount point → select /boot  

3. ROOT PARTITION  
   Select the free space → Create partition  
   a. Size → use all remaining available space  
   b. Type for the new partition → select Primary  
   c. Location for the new partition → select Beginning of this space  
   d. Use as → select physical volume for encryption\*  
   e. Choose a security key → enter your password  
   f. Confirm the security key → confirm your password  
   g. Find the "/dev/mapper/sda3_crypt" partition with ext4 type, click change, then Mount point → select / (root) → OK  

Device for boot loader installation: /dev/sda SOME_DISK_NAME (SIZE)

\* Full disk encryption is strongly recommended. This gives the following advantages:

- No filesystem metadata leaked
- Everything is encrypted, not just certain directories

Linux Mint also offers to encrypt the user's home folder (not recommended). This is useful if other users will be present in the system, but also has other limitations:

- May leak filenames (eCryptfs encrypts filenames by default, but there is an option to disable this)
- Leaks a significant amount of metadata:  
   Directory layout (directory structure, number of files in each directory)  
   File size (with the precision of a block size, generally 4KiB)  
   File metadata; can include owner, permissions, creation date, modification date, access date, and more  
- Data outside of home  
   Some programs will write things on /tmp, log files are going to /var/log, swap will contain sensitive data. Those directories are outside of your home, and will not be protected.  
- Protection against tampering  
   If your computer breaks down for any reason, and you must send it to repairs, your home is protected, your system isn't. It will be trivial to replace binaries, or put backdoors in place.  
- Protect login password, WiFi passwords, and databases  
   The same support technician can copy /etc/shadow, all data from NetworkManager, anything on /var/lib/mysql, and so on. With full disk encryption, nothing can be copied.  

## Setting up the Timeshift

In the schedule tab, select the snapshot levels - month, and the number - 5. Other settings, leave by default.

## Vivaldi Options

Settings:

- Themes --> Issuna
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
mkdir -p $HOME/batterymonitor@pdcurtis && 
cp $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/5.4/stylesheet.css $HOME/batterymonitor@pdcurtis && 
sed -i -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/' -e '0,/red/s//rgba(0,0,0,0)/' $HOME/batterymonitor@pdcurtis/stylesheet.css
```

or to fix the BAMS applet settings directly, use the command below, but you will have to do this when the applet is updated

```bash
sed -i -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e '0,/rgba(0,255,0,0.3)/s//rgba(0,0,0,0)/' -e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/' -e '0,/red/s//rgba(0,0,0,0)/' $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/5.4/stylesheet.css
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

You can change your favorite applications in System Settings --> Preferred applications:

- Music : Celluloid --> SMPlayer
- Video : Celluloid --> SMPlayer

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
