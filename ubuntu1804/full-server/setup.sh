#!/bin/bash

# Variable Definitions
echo "Getting prerequisite information"
read -p 'Default server username: ' USER_NAME
read -p 'Network Share IP: ' NETWORK_SHARE_IP
read -p 'Network Share Username: ' SMB_SHARE_USERNAME
read -sp 'Network Share Password: ' SMB_SHARE_PASSWORD

# Update system
apt update -qq
apt upgrade -yqq

# Install dependencies
apt install cifs-utils docker docker-compose -yqq

# Mount network shares
mkdir /mnt/videos
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Videos /mnt/videos

# Make config locations
mkdir /home/$USER_NAME/.media-config/ > /dev/null
mkdir /home/$USER_NAME/.media-config/plex > /dev/null
mkdir /home/$USER_NAME/.media-config/sonarr/ > /dev/null
mkdir /home/$USER_NAME/.media-config/radarr/ > /dev/null
mkdir /home/$USER_NAME/.media-config/jackett/ > /dev/null
mkdir /home/$USER_NAME/.media-config/ombi/ > /dev/null
mkdir /home/$USER_NAME/.media-config/tautulli/ > /dev/null
mkdir -p /home/$USER_NAME/.transcode/temp > /dev/null
mkdir -p /home/$USER_NAME/vpnconfig/openvpn/ > /dev/null

# Copy VPN information for container
cp /mnt/download/nl-aes-128-cbc-udp-dns.ovpn ~/.media-config/qBittorrent/openvpn/> /dev/null
cp /mnt/download/pia_creds.txt ~/.media-config/qBittorrent/openvpn/ > /dev/null

# Setup docker apps
docker-compse up -d