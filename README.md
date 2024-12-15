# Overview
This Bash script automates the process of setting up a development environment by performing:
- System updates
- Installing necessary packages
- Configuring Git
- Managing SSH keys
- Installing applications
    - Curl
    - Git
    - Visual Studio Code
    - KeePassXC
    - Ansible
    - Vivaldi browser. 
- Removes Firefox
- Cleans up unnecessary packages

### After running script
- After you have runnend the script you should add to `id_rsa` your private key.
- When added the private key run a `ssh-add`

# First Script
This script should run first, afterwards you can run `init-gnome`.

# Mega Script
This script is easily to copy ssh public from mega to local machine. 
Make sure that you check the correct version of the ubuntu in de `wget`and `sudo`command. 

```bash
# Mega SSH
wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd-xUbuntu_24.04_amd64.deb
sudo apt install "$PWD/megacmd-xUbuntu_24.04_amd64.deb"
mega-login [mail] '[password]'
mega-get auth_keys/auth_keys.txt /tmp/
cp /tmp/auth_keys.txt ~/.ssh/id_rsa.pub
```