# linux-mint-install-apps

Installing Apps in Linux Mint

## Quick start

Before running `./1_system_upgrade.sh`, upgrade the Linux kernel via Update Manager (mintUpdate) and reboot.

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
   a. Size → input 512 MB  
   b. Type for the new partition → select Primary  
   c. Location for the new partition → select Beginning of this space  
   d. Use as → select EFI System Partition  

2. BOOT PARTITION  
   Select the free space → Create partition  
   a. Size → input 3072 MB\*  
   b. Type for the new partition → select Primary  
   c. Location for the new partition → select Beginning of this space  
   d. Use as → select Ext4 journaling file system  
   e. Mount point → select /boot  
   f. Find the "/dev/sda2" partition with mount point /boot, click change, then Format the partition → check → Yes  

3. ROOT PARTITION  
   Select the free space → Create partition  
   a. Size → use all remaining available space  
   b. Type for the new partition → select Primary  
   c. Location for the new partition → select Beginning of this space  
   d. Use as → select physical volume for encryption\**  
   e. Choose a security key → enter your password  
   f. Confirm the security key → confirm your password  
   g. Find the "/dev/mapper/sda3_crypt" partition with ext4 type, click change, then Mount point → select / (root) → OK  

Device for boot loader installation: /dev/sda SOME_DISK_NAME (SIZE)

\* As /boot will be a separate filesystem in your setup, do not make /boot smaller than 2 GB, better grant it 3 GB of space. In this partition, the kernels will also be packed and unpacked, which will require additional space. And do not forget to uninstall obsolete kernels regularly nonetheless (see the "Automatically Remove Old Kernels" section). If you do not, even the largest /boot filesystem will be filled sooner or later.

\** Full disk encryption is strongly recommended. This gives the following advantages:

- No filesystem metadata leaked
- Everything is encrypted, not just certain directories

Linux Mint also offers to encrypt the user's home folder (**not recommended**). This is useful if other users will be present in the system, but also has other limitations:

- May leak filenames (eCryptfs encrypts filenames by default, but there is an option to disable this)
- Leaks a significant amount of metadata:  
   - Directory layout (directory structure, number of files in each directory)  
   - File size (with the precision of a block size, generally 4KiB)  
   - File metadata; can include owner, permissions, creation date, modification date, access date, and more  
- Data outside of home  
   - Some programs will write things on /tmp, log files are going to /var/log, swap will contain sensitive data. Those directories are outside of your home, and will not be protected.  

## Automatically Remove Old Kernels

1) Go to System --> Update Manager
2) In Update Manager, click on main menu --> Edit --> Preferences
3) Switch to the Automation tab
4) Turn on the toggle option "Remove obsolete kernels and dependencies"
5) Provide your password to confirm the operation

## Setting up the Timeshift

In the location tab, for the "Select Snapshot Location" field, select: dm-0. In the schedule tab, select the snapshot levels - month, and the number - 3. Other settings, leave by default.

## Vivaldi Options

Settings:

- Themes --> Issuna
- Tabs --> New Tab Position --> After Active Tab
- Tabs --> Enable Horizontal Scrolling
- Search --> Default Search Engine --> Google
- Privacy and Security --> Autoplay --> Block
- Privacy and Security --> Notifications --> Block
- Set your preferred website color theme. Go to Settings > Appearance > Website Appearance to adjust your color theme preferences.

Addons:

- https://chrome.google.com/webstore/detail/bitwarden-free-password-m/nngceckbapebfimnlniiiahkandclblb

## Firefox Options

Addons:

- https://addons.mozilla.org/ru/firefox/addon/ublock-origin/
- https://addons.mozilla.org/ru/firefox/addon/bitwarden-password-manager/
- https://addons.mozilla.org/ru/firefox/addon/new-tab-suspender/
- https://addons.mozilla.org/ru/firefox/addon/musicpro/

## Cinnamon Desktop Environment Settings

### Applets

To prevent updates, go to the update manager and then right-click on the applet and select "Ignore all future updates for this package". To install the applet, simply copy the files to ~/.local/share/cinnamon/applets/

> Battery Applet with Monitoring and Shutdown (BAMS)

Install the BAMS applet (the best version is 1.5.1), then run:

```bash
mkdir -p $HOME/batterymonitor@pdcurtis && \
cp $HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/5.4/stylesheet.css $HOME/batterymonitor@pdcurtis && \
sed -i \
-e 's/rgba(0,255,0,0.3)/rgba(0,0,0,0)/g' \
-e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/g' \
-e '/.bam-discharging {/,/}/{s/border-color: red;/border-color: rgba(0,0,0,0);/}' \
-e 's/margin: 2px, 1px, 0px, 1px;/margin: 0px, 1px, 0px, 1px;/g' \
-e 's/font-size: 95%;/font-size: 100%;/g' \
$HOME/batterymonitor@pdcurtis/stylesheet.css
```

or to fix the BAMS applet settings directly, use the command below, but you will have to do this when the applet is updated

```bash
sed -i \
-e 's/rgba(0,255,0,0.3)/rgba(0,0,0,0)/g' \
-e 's/rgba(0,255,0,0.5)/rgba(0,0,0,0)/g' \
-e '/.bam-discharging {/,/}/{s/border-color: red;/border-color: rgba(0,0,0,0);/}' \
-e 's/margin: 2px, 1px, 0px, 1px;/margin: 0px, 1px, 0px, 1px;/g' \
-e 's/font-size: 95%;/font-size: 100%;/g' \
$HOME/.local/share/cinnamon/applets/batterymonitor@pdcurtis/5.4/stylesheet.css
```

Install dependencies: `sudo apt-get install -y zenity sox libsox-fmt-mp3`

Then, in the applet settings, select the option "Compact - Battery Percentage without extended messages" in the "Display Mode" area.

If the battery data is not displayed, change the path to the battery directory in the advanced configuration to "/sys/class/power_supply/BATT" or to something that starts with BAT

> keyboard@cinnamon.org

It may not be displayed if iBus is installed on the system. Find the application "iBus Preferences", then in General --> disable Show icon on system tray. Then in Advanced --> enable Use system keyboard layout

> ScreenShot+RecordDesktop

Install dependencies: `sudo apt install -y ffmpeg xdotool x11-utils`

> inhibit@cinnamon.org

> expo@cinnamon.org

### Desklets

> diskspace@schorschii

### Desktop wallpapers

- https://wallpaperaccess.com/manjaro
- https://www.reddit.com/r/wallpaper/
- https://www.reddit.com/r/wallpaper/comments/sox44n/chill_vibes_3440_1440/
- https://www.reddit.com/r/wallpaper/comments/sp0j3j/mountain_view_5120x2880/
- https://gitlab.com/tromsite/tromjaro/iso-profiles/-/tree/master/tromjaro/xfce/live-overlay/usr/share/backgrounds

### Change background for login screen

For change the login screen background, run the command below, where "some_file" is the name of the picture file:

`sudo mkdir -p /usr/share/backgrounds/login && sudo cp some_file.jpg /usr/share/backgrounds/login`, then change the background in System Settings --> Login Window.

### Favorite apps

You can change your favorite applications in System Settings --> Preferred applications:

- Music : Celluloid --> SMPlayer
- Video : Celluloid --> SMPlayer

To match SMPlayer's theme with the system for authenticity, you can set the style to gtk2 in its settings.

## Other resources

- `git clone https://gitgud.io/hovereagle/linux-mint-install-nonfree-components.git`
- Go to https://3.jetbra.in/ or to https://jetbra.in/s click on any available hostname and follow the instructions

## VS Code Extensions

1. LaTeX Workshop

    - [James-Yu.latex-workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
    - Command: `code --install-extension James-Yu.latex-workshop`

2. Git Graph

    - [vscode-git-graph](https://github.com/hansu/vscode-git-graph)

## Installing LaTex and using it in VS Code

To install LaTex, run the command: `sudo apt install -y texlive-full latexmk`

1) If VS Code was not installed using this script, then open VS Code and install the latex-workshop extension.

2) Now open any .tex file and press Ctrl+Alt+b to build (or use VSCode Command Palette to run command LaTeX Workshop: Build with Recipe). From the options that pop up, select latexmk recipe.

3) Press Ctrl+Alt+v to view generated PDF file (select the Preview Inside VSCode option to open it side-by-side with the editor). Edit the .tex file to see changes reflected in PDF in real time.

## Krita brushes

- https://www.davidrevoy.com/article854/krita-brushes-2021-bundle

## Redshift

### Installation

Install Redshift and its GTK interface with:

```bash
sudo apt install -y redshift redshift-gtk
```

### Using Redshift without an Internet connection

To determine the location, Redshift uses an external IP. When using a VPN, it will incorrectly set the color scheme for the display. Use the script below to manually set your location for Redshift.

```
JSON=$(curl -s https://json.geoiplookup.io/$(curl -s https://ipinfo.io/ip)) # or curl -s https://ipinfo.io/$(curl -s https://ipinfo.io/ip) 
echo "$JSON" 
LATITUDE=$(echo "$JSON" | sed -En 's/.*"latitude": *([0-9.-]+).*/\1/p') 
LONGITUDE=$(echo "$JSON" | sed -En 's/.*"longitude": *([0-9.-]+).*/\1/p') 
cat << EOF > ~/.config/redshift.conf 
[redshift]
location-provider=manual

[manual]
lat=$LATITUDE
lon=$LONGITUDE
EOF
```

## BleachBit settings

- APT
    - autoclean
    - autoremove
    - clean
- Bash
    - History
- journald
    - clean
- Thumbnails
    - Cache
- Deep scan
    - .DS_Store
    - Thumbs.db
    - Temporary files
- System
    - Clipboard
    - Temporary files
    - Cache
    - Trash
    - Broken desktop files
    - Custom
    - Recent document list
    - Rotated logs

## Install telegram (not from flatpak)

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

## Useful Links

- [Setup Git Instructions](docs/GIT_SETUP.md)
