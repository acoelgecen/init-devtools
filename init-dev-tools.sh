#!/bin/bash

# Update the system package index
echo "Updating system package index"
sudo apt update

# Install necessary dependencies
echo "Installing software properties"
sudo apt install -y software-properties-common apt-transport-https wget

# Add the Ansible PPA (Personal Package Archive)
echo "Adding Ansible repository"
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
echo "Installing Ansible"
sudo apt install -y ansible

# Add the Git PPA and install Git
echo "Installing Git"
sudo apt install -y git

# Add the Microsoft GPG key and VS Code repository
echo "Adding Microsoft GPG key and VS Code repository"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Update package index again after adding new repository
echo "Updating package index after adding VS Code repository"
sudo apt update

# Install Visual Studio Code
echo "Installing Visual Studio Code"
sudo apt install -y code

# Upgrade the system to the latest versions of all packages
echo "Upgrading all system packages"
sudo apt update -y
sudo apt upgrade -y

# Optional: Clean up unused packages and dependencies
echo "Cleaning up unused packages"
sudo apt autoremove -y
sudo apt clean

echo "Installation of Ansible, Git, and VS Code and system upgrade complete"

