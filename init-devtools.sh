#!/bin/bash

GREEN='\033[0;32m'  # ANSI color code for green
YELLOW='\033[0;33m' # ANSI color code for yellow
RED='\033[0;31m'    # ANSI color code for red
NOCOLOR='\033[0m'   # No color / reset ANSI code

# Function to check the success of the last command
check_command() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Command executed successfully.${NOCOLOR}"
    else
        echo -e "${RED}Command failed.${NOCOLOR}"
        exit 1  # Exit the script if any command fails
    fi
}

# Ask for sudo upfront
echo -e "${YELLOW}This script requires sudo privileges. Please enter your password.${NOCOLOR}"
sudo -v
check_command
echo ""

# Update and upgrade packages
echo -e "${YELLOW}Updating package list...${NOCOLOR}"
sudo apt update -y
check_command
sudo apt upgrade -y
check_command
echo ""

# Install essential packages
echo -e "${YELLOW}Installing Curl...${NOCOLOR}"
sudo apt install -y curl
check_command
echo ""

echo -e "${YELLOW}Installing Git...${NOCOLOR}"
sudo apt install -y git
check_command
echo ""

# Git configuration
git_user_name=$(git config --global user.name)
git_user_email=$(git config --global user.email)

if [ -z "$git_user_name" ] || [ -z "$git_user_email" ]; then
    echo -e "${YELLOW}Git global configuration not found. Please enter your Git configuration details.${NOCOLOR}"
    
    read -p "Enter Git user name: " user_name
    read -p "Enter Git user email: " user_email

    echo -e "${YELLOW}Configuring Git...${NOCOLOR}"
    git config --global user.name "$user_name"
    git config --global user.email "$user_email"
    check_command
else
    echo -e "${GREEN}Git is already configured:${NOCOLOR}"
    echo -e "  ${YELLOW}User Name:${NOCOLOR} $git_user_name"
    echo -e "  ${YELLOW}User Email:${NOCOLOR} $git_user_email"
fi
echo ""

# KeePassXC Installation
echo -e "${YELLOW}Installing KeePassXC...${NOCOLOR}"
sudo apt install -y keepassxc
check_command
echo ""

# Source folder
echo -e "${YELLOW}Creating source folder...${NOCOLOR}" 
mkdir -p ~/source
check_command
echo ""

# SSH configuration
echo -e "${YELLOW}Configuring SSH keys...${NOCOLOR}"
mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [[ -f ~/.ssh/id_rsa && -f ~/.ssh/id_rsa.pub ]]; then
    echo -e "${GREEN}SSH key pair already exists. Skipping key creation and ssh-add.${NOCOLOR}"
else
    echo -e "${YELLOW}No existing SSH keys found. Proceeding with key input...${NOCOLOR}"

    read -p "Enter your RSA public key (single line): " rsa_public_key
    echo "$rsa_public_key" > ~/.ssh/id_rsa.pub
    chmod 644 ~/.ssh/id_rsa.pub
    check_command
    echo ""

    echo -e "${YELLOW}Please paste your RSA PRIVATE KEY into a temporary file.${NOCOLOR}"
    echo -e "${YELLOW}Opening nano editor - paste your key, then press Ctrl+X, Y, Enter to save.${NOCOLOR}"
    read -p "Press Enter to continue..."
    
    nano ~/.ssh/id_rsa_temp
    
    if [ -f ~/.ssh/id_rsa_temp ]; then
        mv ~/.ssh/id_rsa_temp ~/.ssh/id_rsa
        chmod 600 ~/.ssh/id_rsa
        check_command
        echo -e "${GREEN}Private key saved successfully.${NOCOLOR}"
    else
        echo -e "${RED}Private key file not found. Please try again.${NOCOLOR}"
        exit 1
    fi

    echo ""
    echo -e "${YELLOW}Adding SSH private key to the agent...${NOCOLOR}"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    check_command
    echo ""
fi

echo ""

# SSH KEY ADDING
echo -e "${YELLOW}Adding SSH Keys.${NOCOLOR}"
ssh-add ~/.ssh/id_rsa
check_command
echo ""

# Development tools
echo -e "${YELLOW}Installing build-essential...${NOCOLOR}"
sudo apt install -y build-essential
check_command
echo ""

# VS Code installation
echo -e "${YELLOW}Installing Visual Studio Code...${NOCOLOR}"

if ! command -v code &> /dev/null; then
    # Only add repo if not already installed
    if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
        rm -f packages.microsoft.gpg
    fi

    sudo apt install -y apt-transport-https
    sudo apt update
    sudo apt install -y code
    check_command
else
    echo -e "${GREEN}VS Code is already installed. Skipping repo setup and installation.${NOCOLOR}"
fi
echo ""


# Python & Ansible Environment Setup
echo -e "${YELLOW}Installing Python and tools...${NOCOLOR}"
sudo apt install -y python3 python3-pip python3-setuptools python3-venv
check_command
echo ""

echo -e "${YELLOW}Creating python-environment folder...${NOCOLOR}"
mkdir -p ~/python-environment
check_command
cd ~/python-environment
echo ""

echo -e "${YELLOW}Creating ansible-env virtual environment...${NOCOLOR}"
python3 -m venv ansible-env
check_command
echo ""

echo -e "${YELLOW}Activating ansible-env...${NOCOLOR}"
source ~/python-environment/ansible-env/bin/activate
check_command
echo ""

echo -e "${YELLOW}Installing Ansible-related Python packages...${NOCOLOR}"
pip install --upgrade pip
pip install boto3 botocore jmespath ansible paramiko pyyaml ansible-lint molecule molecule-docker yamllint
check_command
echo ""

echo -e "${GREEN}Ansible environment setup complete.${NOCOLOR}"
echo ""

echo -e "${YELLOW}Deactivating ansible-env...${NOCOLOR}"
deactivate
echo ""

# Final cleanup
echo -e "${YELLOW}Cleaning up...${NOCOLOR}"
sudo apt autoremove -y
check_command
sudo apt clean
check_command
echo ""

# Finish message
echo -e "${YELLOW}All specified applications have been installed.${NOCOLOR}"
echo ""

# Prompt to reboot
read -p "Press any key to reboot your system now, or Ctrl+C to cancel..." -n1 -s
echo -e "\nRebooting the system..."
sudo reboot
