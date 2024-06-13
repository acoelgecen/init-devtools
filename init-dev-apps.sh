#!/bin/bash

GREEN='\033[0;32m'  # ANSI color code for green
NC='\033[0m'        # No color / reset ANSI code

# Function to check the success of the last command
check_command() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Command executed successfully.${NC}"
    else
        echo -e "${RED}Command failed.${NC}"
        exit 1  # Exit the script if any command fails
    fi
}

# Update package list
echo -e "${GREEN}Updating package list...${NC}"
sudo apt update
check_command
echo ""

sleep 1

# Install Git
echo -e "${GREEN}Installing Git...${NC}"
sudo apt install -y git
check_command
echo ""

sleep 1

# Install KeePassXC
echo -e "${GREEN}Installing KeePassXC...${NC}"
sudo apt install -y keepassxc
check_command
echo ""

sleep 1

# Install Ansible
echo -e "${GREEN}Installing Ansible...${NC}"
sudo apt install -y ansible
check_command
echo ""

sleep 1

# Upgrade all packages to the latest version
echo -e "${GREEN}Upgrading all packages...${NC}"
sudo apt upgrade -y
check_command
echo ""

sleep 1

# Clean up unused packages
echo -e "${GREEN}Cleaning up unused packages...${NC}"
sudo apt autoremove -y
check_command
echo ""

sleep 1

# Clean up apt cache
echo -e "${GREEN}Cleaning up apt cache...${NC}"
sudo apt clean
check_command
echo ""

sleep 1

# Install Visual Studio Code repository and application
echo -e "${GREEN}Installing Visual Studio Code...${NC}"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt install apt-transport-https
sudo apt update
sudo apt install code
check_command
echo ""

sleep 1

echo -e "${GREEN}All specified applications have been installed.${NC}"
echo ""

sleep 1

# Prompt for reboot
read -p "Do you want to reboot your system now? (y/n): " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Rebooting the system...${NC}"
    sudo reboot
else
    echo -e "${GREEN}Please reboot your system later to apply changes.${NC}"
fi
