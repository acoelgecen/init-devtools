#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update

# Fix broken packages
echo "Fixing broken packages..."
sudo apt --fix-broken install -y

# Install Git
echo "Installing Git..."
sudo apt install -y git

# Install KeePassXC
echo "Installing KeePassXC..."
sudo apt install -y keepassxc

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
# Import the Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Update package list after adding VSCode repo
sudo apt update
sudo apt install -y code

# Install Ansible
echo "Installing Ansible..."
sudo apt install -y ansible

# Upgrade all packages to the latest version
echo "Upgrading all packages..."
sudo apt upgrade -y

# Clean up unused packages
echo "Cleaning up unused packages..."
sudo apt autoremove -y

# Clean up apt cache
echo "Cleaning up apt cache..."
sudo apt clean

echo "All specified applications have been installed and the system is rebooting."

# Reboot the system
echo "Rebooting the system..."
sudo reboot