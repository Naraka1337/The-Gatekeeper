#!/bin/bash
# Secure Gatekeeper - Auto Deployment Script
echo "[+] Updating system and installing Apache, OpenSSH, Fail2ban..."
sudo apt update && sudo apt install apache2 openssh-server fail2ban -y

echo "[+] Enabling services..."
sudo systemctl enable --now apache2 ssh fail2ban

echo "[+] Configuring iptables for DDoS Rate Limiting (SYN Flood Protect)..."
# Apply SYN Flood rate limiting on Port 80 (20/s limit, 50 burst)
sudo iptables -A INPUT -p tcp --dport 80 --syn -m limit --limit 20/s --limit-burst 50 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 --syn -j DROP

# Hardening: Enable kernel-level TCP SYN Cookies
sudo sysctl -w net.ipv4.tcp_syncookies=1
echo "net.ipv4.tcp_syncookies = 1" | sudo tee -a /etc/sysctl.conf

echo "[+] Configuring Fail2ban for SSH Protection..."
# Generate SSH protection jail directly to configuration
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[sshd]
enabled = true
port    = ssh
filter  = sshd
logpath = /var/log/auth.log
maxretry = 3
findtime = 10m
bantime  = 1h
EOF

echo "[+] Restarting Fail2ban to apply changes..."
sudo systemctl restart fail2ban

echo "[SUCCESS] Setup Complete! Server is now Protected."
