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
    # Gather Data from Fail2ban
    # Using more robust parsing for Ubuntu 24.04
    STATUS_OUTPUT=$(sudo fail2ban-client status sshd)
    
    BANNED_LIST=$(echo "$STATUS_OUTPUT" | grep "Banned IP list:" | sed -e 's/.*Banned IP list://' -e 's/^[ \t]*//')
    TOTAL_BANNED=$(echo "$STATUS_OUTPUT" | grep "Currently banned:" | grep -oE '[0-9]+' | head -1)
    TOTAL_FAILED=$(echo "$STATUS_OUTPUT" | grep "Total failed:" | grep -oE '[0-9]+' | head -1)

    # Convert list to JSON Array format
    if [ -z "$BANNED_LIST" ]; then
        BANNED_JSON="[]"
    else
        # Format: "ip1", "ip2"
        FORMATTED=$(echo "$BANNED_LIST" | sed 's/ /", "/g')
        BANNED_JSON="[\"$FORMATTED\"]"
    fi
fi

# Get active SSH sessions (More robust syntax for ss)
ACTIVE_SSH=$(ss -t -n state established '( sport = :22 or dport = :22 )' 2>/dev/null | grep -v "Recv-Q" | wc -l)

# Ensure target directory exists
sudo mkdir -p $(dirname "$OUTFILE")

# Write JSON atomically
cat <<EOF > /tmp/data.json.tmp
{
  "total_banned": ${TOTAL_BANNED:-0},
  "total_failed": ${TOTAL_FAILED:-0},
  "banned_ips": $BANNED_JSON,
  "active_ssh": ${ACTIVE_SSH:-0},
  "last_update": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF

# Move and set permissions so Apache (www-data) can read it
sudo mv /tmp/data.json.tmp $OUTFILE
sudo chmod 644 $OUTFILE
sudo chown www-data:www-data $OUTFILE
