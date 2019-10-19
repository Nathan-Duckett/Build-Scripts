#!/bin/sh
read -p 'Network Share IP:' NETWORK_SHARE_IP
read -p 'Network Share Username:' SMB_SHARE_USERNAME

echo "Installing Dependencies"
apt install cifs-utils docker docker-compose -y &
echo "Finished Install Dependencies"

# Mount SMB Network Shares
echo "Mounting shares and setting up configs"
mkdir /mnt/download &
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Download /mnt/download &
mkdir -p ~/vpnconfig/openvpn/ &
cp /mnt/download/nl-aes-128-cbc-udp-dns.ovpn ~/vpnconfig/openvpn/ &
cp /mnt/download/pia_creds.txt ~/vpnconfig/openvpn/ &

echo "Building qBittorrent Docker"
cd docker-builds/qBittorrent-only/
docker-compose up -d