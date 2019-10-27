#!/bin/bash

### Author: Nathan Duckett
### Bash Script to Build the full server using docker services
### Completly installs all software which is required.
###

# Check root permission
if [ $EUID != 0 ]; then
    echo "You must run this script as root"
    exit
fi

echo "Getting prerequisite information"
read -p 'Default server username: ' USER_NAME
read -p 'Network Share IP: ' NETWORK_SHARE_IP
read -p 'Network Share Username: ' SMB_SHARE_USERNAME
read -sp 'Network Share Password: ' SMB_SHARE_PASSWORD

apt update -qq > /dev/null
apt upgrade -qq > /dev/null
apt install cifs-utils docker docker-compose -qq > /dev/null

# Mount SMB Network Shares
echo "Mounting network shares"
cat > ~/.smbcredentials << EOF
username=$SMB_SHARE_USERNAME
passsword=$SMB_SHARE_PASSWORD
EOF
chmod 600 ~/.smbcredentials
mkdir /mnt/download > /dev/null
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/Download /mnt/download > /dev/null
mkdir /mnt/videos > /dev/null
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/Videos /mnt/videos > /dev/null
echo "//$NETWORK_SHARE_IP/Download /mnt/download cifs credentials=/home/$USER_NAME/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab
echo "//$NETWORK_SHARE_IP/Videos /mnt/videos cifs credentials=/home/$USER_NAME/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab

# Create config folder locations
mkdir /home/$USER_NAME/.media-config/ > /dev/null
mkdir /home/$USER_NAME/.media-config/plex > /dev/null
mkdir /home/$USER_NAME/.media-config/sonarr/ > /dev/null
mkdir /home/$USER_NAME/.media-config/radarr/ > /dev/null
mkdir /home/$USER_NAME/.media-config/jackett/ > /dev/null
mkdir -p /home/$USER_NAME/.transcode/temp > /dev/null
mkdir -p /home/$USER_NAME/vpnconfig/openvpn/ > /dev/null

# Transfer necessary VPN credentials from Download share
cp /mnt/download/nl-aes-128-cbc-udp-dns.ovpn ~/vpnconfig/openvpn/ > /dev/null
cp /mnt/download/pia_creds.txt ~/vpnconfig/openvpn/ > /dev/null

# Build Docker Containers
echo "Building Docker Containers"
# Media Docker
cd docker-builds/media/
docker-compose up -d > /dev/null

# Plex Docker
cd ../plex-only/
docker-compose up -d > /dev/null

# qBittorrent Docker
cd ../qBittorrent-only/
docker-compose up -d > /dev/null
