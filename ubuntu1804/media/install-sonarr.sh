#!/bin/sh

# Create downloading directory for setup files
mkdir script_auto_download/
cd script_auto_download/

# Download and install Sonarr
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xA236C58F409091A18ACA53CBEBFF6B99D9B78493
echo "deb http://apt.sonarr.tv/ master main" > /etc/apt/sources.list.d/sonarr.list
apt install nzbdrone
cat > sonarr.service << EOF
[Unit]
Description=Sonarr Daemon
After=syslog.target network.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/bin/mono /opt/NzbDrone/NzbDrone.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
mv sonarr.service /lib/systemd/system/sonarr.service
systemctl enable sonarr.service
systemctl start sonarr.service

# Clear up setup files
cd ../
rm -rf script_auto_download/