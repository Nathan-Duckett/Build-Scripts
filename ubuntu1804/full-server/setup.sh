#!/bin/bash

# Check root privilege
if [ $EUID != 0 ]; then
    echo "You must run this as root"
    exit
fi

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

cat > ~/.smbcredentials << EOF
username=$SMB_SHARE_USERNAME
passsword=$SMB_SHARE_PASSWORD
EOF
chmod 600 ~/.smbcredentials

# Mount network shares
mkdir /mnt/media-movies
mkdir /mnt/media-television
mkdir /mnt/lacie-movies
mkdir /mnt/lacie-television

mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/Media-Movies /mnt/media-movies
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/Media-Television /mnt/media-television
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/LaCie-Movies /mnt/lacie-movies
mount -t cifs -o "user=$SMB_SHARE_USERNAME,password=$SMB_SHARE_PASSWORD" //$NETWORK_SHARE_IP/LaCie-Television /mnt/lacie-television

# Add network shares to boot
echo "//$NETWORK_SHARE_IP/Media-Movies /mnt/media-movies cifs credentials=/home/$USER_NAME/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab
echo "//$NETWORK_SHARE_IP/Media-Movies /mnt/media-television cifs credentials=/home/$USER_NAME/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab
echo "//$NETWORK_SHARE_IP/LaCie-Movies /mnt/lacie-movies cifs credentials=/home/$USER_NAME/.smbcredentials,iocharset=utf8,sec=ntlm 0 0" >> /etc/fstab
echo "//$NETWORK_SHARE_IP/LaCie-Television /mnt/lacie-television cifs credentials=/home/$USER_NAME/.smbcredentials,iocharset=utf8,sec=ntlm 0 >> /etc/fstab

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
