#!/bin/bash
# ==============================================================================
# Script: update-data.sh
# Description: Gathers Fail2ban/SSH stats and writes them to data.json for the Dashboard
# ==============================================================================

OUTFILE="/var/www/dashboard/data.json"

# Gather Data
BANNED_LIST=$(sudo fail2ban-client status sshd | grep "Banned IP list:" | sed -e 's/.*Banned IP list://' -e 's/^[ \t]*//')
TOTAL_BANNED=$(sudo fail2ban-client status sshd | grep "Currently banned:" | awk '{print $4}')
TOTAL_FAILED=$(sudo fail2ban-client status sshd | grep "Total failed:" | awk '{print $4}')

# Get active SSH sessions (excluding the grep command itself)
ACTIVE_SSH=$(ss -tn state established '( dport = :22 or sport = :22 )' 2>/dev/null | grep -v Recv-Q | wc -l)

# Convert list to JSON Array format
if [ -z "$BANNED_LIST" ]; then
    BANNED_JSON="[]"
else
    # Format: "ip1", "ip2"
    FORMATTED=$(echo $BANNED_LIST | sed 's/ /", "/g')
    BANNED_JSON="[\"$FORMATTED\"]"
fi

# Ensure web root exists
sudo mkdir -p /var/www/html

# Write Atomic JSON
cat <<EOF > /tmp/data.json.tmp
{
  "total_banned": ${TOTAL_BANNED:-0},
  "total_failed": ${TOTAL_FAILED:-0},
  "banned_ips": $BANNED_JSON,
  "active_ssh": ${ACTIVE_SSH:-0},
  "last_update": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF

sudo mv /tmp/data.json.tmp $OUTFILE
sudo chmod 644 $OUTFILE
