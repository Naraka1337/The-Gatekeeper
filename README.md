# 🛡️ The Secure Gatekeeper (SOC Dashboard)
**Advanced Threat Mitigation & Real-Time Monitoring System**

The Secure Gatekeeper is a production-ready cybersecurity monitoring and mitigation suite designed to protect Ubuntu-based environments from sophisticated network attacks. It integrates kernel-level filtering with application-layer intelligence to provide a high-end, visual SOC (Security Operations Center) experience.

---

## 🚀 Key Features

### 1. Advanced Network Hardening
*   **SYN Flood Mitigation**: Automated `iptables` rate-limiting and TCP SYN Cookies to prevent connection exhaustion.
*   **SSH Brute Force Protection**: Deep packet inspection and log analysis via `Fail2ban` to quarantine aggressive IPs.
*   **TCP Stack Tuning**: Hardened kernel parameters for enhanced network stability during attack conditions.

### 2. Interactive SOC Dashboard (Port 8080)
*   **Real-Time Analytics**: Live monitoring of active block rules, attack vectors, and legitimate sessions.
*   **Fintech-Inspired Design**: Professional-grade, dark-mode glassmorphism interface for high-impact visual presentation.
*   **Interactive Control**: Ability to manually release (unban) IPs directly from the web interface via a secure PHP API.

### 3. Immediate Response System
*   **Telegram Alerts**: Instant notification of security breaches, including origin IP and attack duration.
*   **Automated Quarantining**: Real-time enforcement of ban policies across all network layers.

---

## 📂 Project Architecture

```text
The-Secure-Gatekeeper/
├── init.sh                # Interactive configuration & setup
├── deploy.sh              # Main production deployment engine
├── setup_gatekeeper.sh    # Lightweight VM hardening script
├── telegram-alert.sh      # Alerting integration logic
├── jail.local             # Custom security enforcement policies
└── dashboard/             
    ├── index.html         # Frontend SOC Interface
    ├── api.php            # Interactive Control API
    └── update-data.sh     # Backend data aggregation engine
```

---

## 🛠️ Deployment Instructions

### Prerequisites
*   Ubuntu Server (18.04+)
*   Root or Sudo privileges
*   A Telegram Bot (for notifications)

### Step 1: Initialization
Transfer the project folder to your server and run the interactive setup:
```bash
chmod +x init.sh
./init.sh
```
*This will prompt you for your Telegram API credentials and set the necessary file permissions.*

### Step 2: Deployment
Execute the main deployment engine:
```bash
sudo ./deploy.sh
```

### Step 3: Access
*   **Main Website**: `http://<SERVER_IP>`
*   **SOC Dashboard**: `http://<SERVER_IP>:8080`

---

## 🧪 Security Lab Testing
To validate the system using a Kali Linux machine:

1.  **SSH Brute Force**: Run `hydra -l root -p 12345 ssh://<SERVER_IP>` to trigger the ban.
2.  **SYN Flood**: Run `sudo hping3 -S -p 80 --flood <SERVER_IP>` to test rate limiting.
3.  **Verification**: Monitor the dashboard on port 8080 to see the system react in real-time.

---

## ⚖️ Disclaimer
This tool is designed for security monitoring and educational purposes. Ensure you have authorized access before conducting any penetration tests.

---
**Developed for Secure Infrastructure Monitoring v1.2.0**
