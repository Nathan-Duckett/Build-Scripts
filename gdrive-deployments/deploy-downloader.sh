#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Script must be run as root"
    exit 1
fi

read -p 'Network Share IP: ' NETWORK_SHARE_IP
read -p 'Network Share Username: ' SMB_SHARE_USERNAME

echo "Installing Dependencies"
apt update -qq && apt upgrade -y -qq > /dev/null
apt install arch-install-scripts cifs-utils docker docker-compose -y -qq > /dev/null

# Move back to root directory
cd ..

mkdir /mnt/download > /dev/null
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Download /mnt/download

genfstab -U /mnt/download >> /etc/fstab

# Create config folder locations
mkdir -p ~/.media-config/qBittorrent/openvpn/ > /dev/null
# Copy credentials to configuration location
cp /mnt/download/nl-aes-128-cbc-udp-dns.ovpn ~/.media-config/qBittorrent/openvpn/> /dev/null
cp /mnt/download/pia_creds.txt ~/.media-config/qBittorrent/openvpn/ > /dev/null

# Add user permissions to user 'nathan' use docker
usermod -aG docker nathan

# Deploy all docker containers
cd docker-builds/qBittorrent-only/
docker-compose up -d