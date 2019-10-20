#!/bin/sh
# Create downloading directory for setup files
mkdir script_auto_download/
cd script_auto_download/

# Download and install Jackett
wget -q https://github.com/Jackett/Jackett/releases/download/v0.11.817/Jackett.Binaries.LinuxAMDx64.tar.gz
tar zxvf Jackett.Binaries.LinuxAMDx64.tar.gz -C /opt/
/opt/Jackett/install_service_systemd.sh
systemctl enable jackett.service
systemctl start jackett.service

# Clear up setup files
cd ../
rm -rf script_auto_download/