#!/bin/bash
# ==============================================================================
# Script: update-data.sh
# Description: Gathers Fail2ban/SSH stats and writes them to data.json for the Dashboard
# ==============================================================================

OUTFILE="/var/www/dashboard/data.json"

# Check if fail2ban is responsive before querying
if ! sudo fail2ban-client ping >/dev/null 2>&1; then
    TOTAL_BANNED=0
    TOTAL_FAILED=0
    BANNED_JSON="[]"
else
    # Gather Data from Fail2ban - Using more aggressive parsing for Ubuntu 24.04
    STATUS_OUTPUT=$(sudo fail2ban-client status sshd)
    
    # Extract numbers regardless of tabs or spaces
    TOTAL_BANNED=$(echo "$STATUS_OUTPUT" | grep -i "Currently banned:" | grep -oE '[0-9]+' | tail -1)
    TOTAL_FAILED=$(echo "$STATUS_OUTPUT" | grep -i "Total failed:" | grep -oE '[0-9]+' | tail -1)
    
    # Extract IP list and handle commas/spaces
    BANNED_LIST=$(echo "$STATUS_OUTPUT" | grep -i "Banned IP list:" | sed 's/.*Banned IP list://' | tr ',' ' ' | xargs)

    # Convert list to JSON Array format
    if [ -z "$BANNED_LIST" ]; then
        BANNED_JSON="[]"
    else
        # Format: "ip1", "ip2"
        FORMATTED=$(echo "$BANNED_LIST" | sed 's/ /", "/g')
        BANNED_JSON="[\"$FORMATTED\"]"
    fi
fi

# Get active SSH sessions (Using 'who' - the most reliable way)
ACTIVE_SSH=$(who | grep -v "tty" | wc -l)

# Ensure target directory exists
sudo mkdir -p $(dirname "$OUTFILE")

# Write JSON atomically
cat <<EOF > /tmp/data.json.tmp
{
  "total_banned": ${TOTAL_BANNED:-0},
  "total_failed": ${TOTAL_FAILED:-0},
  "banned_ips": $BANNED_JSON,
  "active_ssh": ${ACTIVE_SSH:-0},
  "last_update": "$(date '+%H:%M:%S')"
}
EOF

# Move and set permissions
sudo mv /tmp/data.json.tmp $OUTFILE
sudo chmod 644 $OUTFILE
sudo chown www-data:www-data $OUTFILE
