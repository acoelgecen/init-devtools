#!/bin/bash

# Ansible
echo "Updating system"
sudo apt update
echo "Installing software properties"
sudo apt install -y software-properties-common
echo "Adding ansible repository"
sudo add-apt-repository --yes --update ppa:ansible/ansible
echo "Installing ansible"
sudo apt install -y ansible
echo "Upgrading system"
sudo apt update -y
echo "Updating system"
sudo apt upgrade -y

# VS-Code
