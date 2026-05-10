#!/bin/bash
# ==============================================================================
# Project: The Secure Gatekeeper - Auto Deployment Script
# ==============================================================================

echo -e "\e[1;32m[+] Updating system and installing services...\e[0m"
sudo apt update && sudo apt install apache2 openssh-server fail2ban curl php libapache2-mod-php rsyslog python3-systemd -y

echo -e "\e[1;32m[+] Copying configurations from IDE Workspace...\e[0m"
# Install and authorize the alert script
sudo cp telegram-alert.sh /usr/local/bin/telegram-alert.sh
sudo chmod +x /usr/local/bin/telegram-alert.sh

# Load custom fail2ban jail configurations
cat <<EOF | sudo tee /etc/fail2ban/jail.local > /dev/null
[sshd]
enabled = true
port    = ssh
filter  = sshd
backend = systemd
maxretry = 3
findtime = 10m
bantime  = 1h
# Simple action to test ban first
action = iptables-multiport[name=SSH, port="ssh", protocol=tcp]
         shell[actionban="/usr/local/bin/telegram-alert.sh <ip>"]
EOF

echo -e "\e[1;32m[+] Setting up the Web Monitoring Dashboard on Port 8080...\e[0m"
# Provision Web Monitoring Dashboard to a separate directory
sudo mkdir -p /var/www/dashboard
sudo cp dashboard/index.html /var/www/dashboard/index.html
sudo cp dashboard/api.php /var/www/dashboard/api.php
sudo cp dashboard/update-data.sh /usr/local/bin/update-data.sh
sudo chmod +x /usr/local/bin/update-data.sh

echo -e "\e[1;32m[+] Configuring Sudo Permissions for Dashboard Control...\e[0m"
# Allow Apache user (www-data) to unban IPs without password
echo "www-data ALL=(ALL) NOPASSWD: /usr/bin/fail2ban-client unban *" | sudo tee /etc/sudoers.d/gatekeeper > /dev/null
sudo chmod 0440 /etc/sudoers.d/gatekeeper

# Configure Apache to listen on Port 8080 for the SOC Dashboard
if ! grep -q "Listen 8080" /etc/apache2/ports.conf; then
    echo "Listen 8080" | sudo tee -a /etc/apache2/ports.conf > /dev/null
fi

sudo tee /etc/apache2/sites-available/dashboard.conf > /dev/null <<EOF
<VirtualHost *:8080>
    DocumentRoot /var/www/dashboard
    ErrorLog \${APACHE_LOG_DIR}/dashboard_error.log
    CustomLog \${APACHE_LOG_DIR}/dashboard_access.log combined
</VirtualHost>
EOF

sudo a2ensite dashboard.conf
sudo systemctl restart apache2


# Register crontab entry for real-time data sync
(crontab -l 2>/dev/null | grep -v "update-data.sh" ; echo "* * * * * /usr/local/bin/update-data.sh") | crontab -
sudo /usr/local/bin/update-data.sh # Initial data population

echo -e "\e[1;32m[+] Applying TCP hardening (SYN Cookies)...\e[0m"
sudo sysctl -w net.ipv4.tcp_syncookies=1
if ! grep -q "net.ipv4.tcp_syncookies" /etc/sysctl.conf; then
    echo "net.ipv4.tcp_syncookies = 1" | sudo tee -a /etc/sysctl.conf
fi

echo -e "\e[1;32m[+] Configuring iptables Rules...\e[0m"
sudo iptables -F
# Apply SYN Flood rate limiting on Port 80
sudo iptables -A INPUT -p tcp --dport 80 --syn -m limit --limit 20/s --limit-burst 50 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 --syn -j DROP
# Allow Admin Access to Monitoring Dashboard on Port 8080
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

echo -e "\e[1;32m[+] Enabling and Restarting Services...\e[0m"
sudo systemctl enable --now apache2 ssh fail2ban
sudo systemctl restart fail2ban

echo -e "\e[1;35m[SUCCESS] Deployment Complete! Your Gatekeeper is fully functional.\e[0m"
