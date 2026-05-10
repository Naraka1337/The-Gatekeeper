#!/bin/bash
# ==============================================================================
# Project: The Secure Gatekeeper - Initialization Script
# Description: Interactive setup for API keys and permissions
# ==============================================================================

# Colors for UI
GREEN='\e[1;32m'
CYAN='\e[1;36m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

echo -e "${CYAN}==================================================${NC}"
echo -e "${CYAN}      The Secure Gatekeeper - Initial Setup       ${NC}"
echo -e "${CYAN}==================================================${NC}"

# Prompt for Telegram Credentials
echo -e "\n${YELLOW}[?] Step 1: Telegram Notification Setup${NC}"
read -p "Enter your Telegram Bot Token: " TELEGRAM_TOKEN
read -p "Enter your Telegram Chat ID: " TELEGRAM_CHAT_ID

# Update telegram-alert.sh using sed
if [ -f "telegram-alert.sh" ]; then
    # Use a different delimiter (|) for sed to avoid issues with potential slashes in tokens
    sed -i "s|TOKEN=\".*\"|TOKEN=\"$TELEGRAM_TOKEN\"|" telegram-alert.sh
    sed -i "s|CHAT_ID=\".*\"|CHAT_ID=\"$TELEGRAM_CHAT_ID\"|" telegram-alert.sh
    echo -e "${GREEN}[+] Credentials saved to telegram-alert.sh${NC}"
else
    echo -e "\e[1;31m[!] Error: telegram-alert.sh not found!${NC}"
    exit 1
fi

# Make all core scripts executable
echo -e "\n${YELLOW}[?] Step 2: Setting Permissions${NC}"
chmod +x deploy.sh
chmod +x setup_gatekeeper.sh
chmod +x telegram-alert.sh
chmod +x dashboard/update-data.sh
echo -e "${GREEN}[+] All deployment and utility scripts are now executable.${NC}"

echo -e "\n${CYAN}==================================================${NC}"
echo -e "${GREEN}Configuration Complete!${NC}"
echo -e "You can now run the main deployment script:"
echo -e "${YELLOW}sudo ./deploy.sh${NC}"
echo -e "${CYAN}==================================================${NC}"
