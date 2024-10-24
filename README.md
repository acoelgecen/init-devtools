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
