#!/bin/sh

# Create downloading directory for setup files
mkdir script_auto_download/
cd script_auto_download/

# Download and install Radarr
wget -q https://github.com/Radarr/Radarr/releases/download/v0.2.0.1358/Radarr.develop.0.2.0.1358.linux.tar.gz
tar zxvf Radarr.develop.0.2.0.1358.linux.tar.gz -C /opt/
cat > radarr.service << EOF
[Unit]
Description=Radarr Daemon
After=syslog.target network.target

[Service]
User=root
Group=root
Restart=always
RestartSec=5
Type=simple

ExecStart=/usr/bin/mono --debug /opt/Radarr/Radarr.exe --nobrowser
TimeoutStopSec=20
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
mv radarr.service /lib/systemd/system/radarr.service
systemctl enable radarr.service
systemctl start radarr.service


# Clear up setup files
cd ../
rm -rf script_auto_download/