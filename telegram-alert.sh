#!/bin/bash
# ==============================================================================
# Script: telegram-alert.sh
# Description: Sends an instant notification to Telegram when an IP gets banned.
# ==============================================================================

# Configuration: Set your Telegram Bot credentials here
TOKEN="YOUR_BOT_TOKEN_HERE"
CHAT_ID="YOUR_CHAT_ID_HERE"

BANNED_IP=$1

if [ -z "$BANNED_IP" ]; then
    BANNED_IP="Unknown IP"
fi

MESSAGE="[Gatekeeper Alert] %0A%0A[SSH Brute Force Attack detected!]%0A Banned IP: \`$BANNED_IP\`%0A Duration: 1 Hour"

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
     -d "chat_id=$CHAT_ID" \
     -d "text=$MESSAGE" \
     -d "parse_mode=Markdown"
