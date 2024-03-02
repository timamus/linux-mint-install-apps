## Cloning Repositories via SSH

Let's set up SSH for cloning repositories.

1. Create an SSH folder:
```bash
mkdir -p ~/.ssh
```

2. Copy your private key named "<YOUR_PRIVATE>_rsa" to the `~/.ssh` directory.

3. Set the appropriate permissions and generate the configuration file:
```bash
chmod 600 ~/.ssh/<YOUR_PRIVATE>_rsa
cat > ~/.ssh/config <<EOL
Host github.com
    HostName github.com
    PreferredAuthentications publickey
    IdentityFile ~/.ssh/<YOUR_PRIVATE>_rsa
EOL
```

4. To clone your repository, run:
```bash
git clone git@github.com:<YOUR_USERNAME>/<YOUR_REPOSITORY>.git
```
When prompted, type "yes" to continue.

> **Note:** This method also works for Windows. Ensure that you have OpenSSH installed. Copy the private key to `C:\Users\<YOUR_USER_NAME>\.ssh\`. If you don't have SSH keys, generate them using the SSH commands in the OpenSSH directory and register them on your hosting service platform.

## Cloning repositories via HTTPS: Obsidian Vault example

To synchronize your obsidian vault over HTTPS, use the following script:

```bash
git clone https://github.com/USERNAME/obsidian-vault.git && 
cd obsidian-vault && 
git config user.email "YOUR_EMAIL@gmail.com" && 
git config user.name "USERNAME" && 
git config credential.helper store && git pull
```

You will need to enter your username and GitHub token twice. The second time git-credential-store (helper to store credentials on disk) will save your passwords to disk in the file "~/.git-credentials". For example, on the command line you would enter the following:

```
Username: YOUR_USERNAME
Password: YOUR_TOKEN
```

.gitignore file may contain the following:

```
.obsidian/workspace
.obsidian/cache
```

### Obsidian Settings

- Settings --> Community plugins --> Obsidian Git --> Backup --> Pull updates on startup

To save the Obsidian vault, press Ctrl+P, type "commit" and select "Obsidian Git: Commit all changes", then type 'push' and select "Obsidian Git: Push"

### Obsidian settings on Android

- Install Termux, then open it
- Run `termux-change-repo`. Press enter to move to the next screen. Press ↓, then spacebar to tick the "Mirrors hosted by Albatross", press enter
- Run `pkg install git`
- Run `termux-setup-storage`, then allow access
- Run `cd /storage/emulated/0/Documents`
- Run `git clone https://github.com/USERNAME/obsidian-vault.git`, and enter your login when prompted. You can insert a token from the clipboard by pressing the command line
- Run `ls` to see that the vault has been cloned
- Then open Obsidian, open the cloned folder as vault, then Settings --> Community plugins --> Obsidian Git --> and fill in the fields "Authentication/Commit Author"
