# The Secure Gatekeeper
**SOC Monitoring & Network Threat Mitigation**

A security suite for Ubuntu servers that combines Fail2ban log analysis with iptables kernel-level filtering. Features a real-time SOC dashboard for live attack visualization and interactive threat management.

## Technical Specifications
- **L3/L4 Protection**: SYN Flood mitigation via iptables rate-limiting and TCP SYN Cookies.
- **SSH Hardening**: Automated brute-force detection and IP quarantining.
- **SOC Dashboard**: Fintech-style monitoring interface served via Apache (Port 8080).
- **Interactive Control**: PHP-based API for manual IP release (unban) directly from the UI.
- **Notifications**: Instant Telegram alerts for security enforcement actions.

## Project Structure
- `init.sh`: Interactive environment configuration and credential setup.
- `deploy.sh`: Primary deployment script for production environments.
- `setup_gatekeeper.sh`: Standalone hardening script for quick VM protection.
- `telegram-alert.sh`: Logic for external notification triggers.
- `jail.local`: Security policy definitions for Fail2ban.
- `dashboard/`: SOC frontend and backend data processing.

## Deployment Guide

### 1. Initialization
Clone the repository to the target Ubuntu machine and run the setup script:
```bash
chmod +x init.sh
./init.sh
```
Follow the prompts to configure your Telegram API Token and Chat ID.

### 2. Full Deployment
Run the main deployment engine to provision Apache, Fail2ban, and the SOC Dashboard:
```bash
sudo ./deploy.sh
```

### 3. Service Endpoints
- **Main Web Application**: `http://<SERVER_IP>`
- **SOC Monitoring Console**: `http://<SERVER_IP>:8080`

## Testing and Validation
To verify the security layers from an external machine (e.g., Kali Linux):

1. **SSH Brute Force**:
   `hydra -l root -p 12345 ssh://<SERVER_IP>`
2. **SYN Flood Simulation**:
   `sudo hping3 -S -p 80 --flood <SERVER_IP>`

Check the Dashboard (Port 8080) for real-time ban events and log updates.

## Disclaimer
This project is for educational and authorized monitoring purposes only. Conduct penetration testing only on systems you own or have explicit permission to audit.

---
v1.2.0 | SOC Infrastructure Monitoring
