# The Secure Gatekeeper

A comprehensive network security project designed to protect web servers and SSH from SYN Flood and Brute Force attacks using `iptables` and `fail2ban`. Includes real-time Telegram notifications for banned IPs.

## Files
- `deploy.sh`: Main deployment script using local configurations.
- `setup_gatekeeper.sh`: Standalone automated script for quick setup on a VM.
- `telegram-alert.sh`: Telegram notification script.
- `jail.local`: Custom Fail2ban configuration.

## How to Deploy
1. Update `telegram-alert.sh` with your Telegram Bot Token and Chat ID.
2. Transfer the `The-Secure-Gatekeeper` folder to your Ubuntu VM.
3. Make the scripts executable:
   ```bash
   chmod +x deploy.sh telegram-alert.sh setup_gatekeeper.sh
   ```
4. Run the main deployment script:
   ```bash
   sudo ./deploy.sh
   ```
