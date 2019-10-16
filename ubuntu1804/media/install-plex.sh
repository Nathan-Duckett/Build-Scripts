#!/bin/sh

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
chown plex:plex /mnt/videos/
chmod +rx /mnt/videos/

# Clear downloads
cd ../
rm -rf script_auto_download/