#!/bin/bash

# Check if the script is run as root
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

# Define function
repairPanel() {
    cd /var/www/pterodactyl || exit

    php artisan down

    rm -r /var/www/pterodactyl/resources

    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv

    chmod -R 755 storage/* bootstrap/cache

    composer install --no-dev --optimize-autoloader

    php artisan view:clear
    php artisan config:clear
    php artisan migrate --seed --force

    chown -R www-data:www-data /var/www/pterodactyl/*

    php artisan queue:restart
    php artisan up

    echo "✅ Theme removed and panel repaired!"
}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# GUI
clear
echo -e "${CYAN}"
cat << "EOF"
  _   _           _     _____                 _                                  _   
 | \ | |         | |   |  __ \               | |                                | |  
 |  \| | _____  _| |_  | |  | | _____   _____| | ___  _ __  _ __ ___   ___ _ __ | |_ 
 | .  |/ _ \ \/ / __| | |  | |/ _ \ \ / / _ \ |/ _ \| '_ \| '_  _ \ / _ \ '_ \| __|
 | |\  |  __/>  <| |_  | |__| |  __/\ V /  __/ | (_) | |_) | | | | | |  __/ | | | |_ 
 |_| \_|\___/_/\_\\__| |_____/ \___| \_/ \___|_|\___/| .__/|_| |_| |_|\___|_| |_|\__|
                                                     | |                             
                                                     |_|                             
EOF
echo -e "${YELLOW}🔥 NextDevelopment Panel Repair ⚡"
echo -e "             🛡 MADE BY NINJA${NC}"
echo ""
echo -e "${CYAN}Choose your GOD MODE OPTION:${NC}"
echo ""
echo -e "${GREEN}1️⃣ REMOVE Theme (Restore original panel) 🧹${NC}"
echo ""
read -p "Enter choice [1]: " choice

case $choice in
    1)
        echo -e "${YELLOW}You selected: REMOVE THEME${NC}"
        while true; do
            read -p "Are you sure you want to REMOVE the theme? [y/n]: " yn
            case $yn in
                [Yy]* ) repairPanel; break;;
                [Nn]* ) echo "❌ Canceled."; exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
        ;;
    *)
        echo "Invalid option, only option [1] is available."
        ;;
esac
