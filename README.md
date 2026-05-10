# The Secure Gatekeeper

A comprehensive network security project designed to protect web servers and SSH from SYN Flood and Brute Force attacks using `iptables` and `fail2ban`. Includes real-time Telegram notifications for banned IPs.

## Files
- `deploy.sh`: Main deployment script using local configurations.
- `setup_gatekeeper.sh`: Standalone automated script for quick setup on a VM.
- `telegram-alert.sh`: Telegram notification script.
- `jail.local`: Custom Fail2ban configuration.

## How to Deploy
1. Transfer the `The-Secure-Gatekeeper` folder to your Ubuntu VM.
2. Run the initialization script to set up your Telegram credentials:
   ```bash
   chmod +x init.sh
   ./init.sh
   ```
3. Run the main deployment script:
   ```bash
   sudo ./deploy.sh
   ```
