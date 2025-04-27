#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo -e "${YELLOW}"
echo "==========================================="
echo "     NextDevelopment Panel Repair Tool     "
echo "==========================================="
echo -e "${NC}"

# Check if user is root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ This script must be run as root${NC}" 
   exit 1
fi

# Install necessary packages
echo -e "${GREEN}➤ Checking and installing required packages...${NC}"
apt update
apt install -y curl unzip git composer php-cli

# Clone the repository
echo -e "${GREEN}➤ Downloading Panel Repair Tool...${NC}"
git clone https://github.com/next-ninja/pterodactyl-theme-remover.git /opt/pterodactyl-theme-remover

# Go to the directory
cd /opt/pterodactyl-theme-remover || exit

# Make main script executable
chmod +x repair.sh

# Run the main script
echo -e "${GREEN}➤ Launching Panel Repair Tool...${NC}"
bash repair.sh
