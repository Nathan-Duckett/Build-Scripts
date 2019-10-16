#!/bin/sh

# Create downloading directory for setup files
mkdir script_auto_download/
cd script_auto_download/

# Download and install Jackett
wget -q https://github.com/Jackett/Jackett/releases/download/v0.11.817/Jackett.Binaries.LinuxAMDx64.tar.gz
tar zxvf Jackett.Binaries.LinuxAMDx64.tar.gz -C /opt/
cat > jackett.service << EOF
[Unit]
Description=Jackett Daemon
After=network.target

[Service]
WorkingDirectory=/opt/Jackett/
User=root
Restart=always
RestartSec=5
Type=simple
ExecStart=/usr/bin/mono /opt/Jackett/JackettConsole.exe  --NoRestart
TimeoutStopSec=20

[Install]
WantedBy=multi-user.target
EOF
mv jackett.service /lib/systemd/system/jackett.service
systemctl enable jackett
systemctl start jackett

# Clear up setup files
cd ../
rm -rf script_auto_download/