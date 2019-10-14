#!/bin/bash
NETWORK_SHARE_IP = 192.168.1.39
SMB_SHARE_USERNAME = natha

# Update and install dependencies
apt update && apt upgrade -y
apt install -y git docker cifs-utils
apt install -y libcurl4-openssl-dev mono-devel

# Mount SMB Network Shares
mkdir /mnt/videos
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Videos /mnt/videos

# Create downloading directory for setup files
mkdir script_auto_download/
cd script_auto_download/

# Download and install plex
wget -q https://downloads.plex.tv/plex-media-server-new/1.18.0.1913-e5cc93306/debian/plexmediaserver_1.18.0.1913-e5cc93306_amd64.deb
dpkg -i plexmediaserver_1.18.0.1913-e5cc93306_amd64.deb
systemctl start plexmediaserver
echo "deb https://downloads.plex.tv/repo/deb/ public main" > /etc/apt/sources.list.d/plexmediaserver.list
wget -q https://downloads.plex.tv/plex-keys/PlexSign.key -O - | apt-key add -
apt update
# Allow plex to access video data
chown plex:root /mnt/videos/
chmod +rx /mnt/videos/

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

# Download and install Sonarr
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC
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


# Clear setup files
cd ..
rm -rf script_auto_download/