#!/bin/sh
NETWORK_SHARE_IP=192.168.1.39
SMB_SHARE_USERNAME=natha

apt install cifs-utils docker docker-compose -y

# Mount SMB Network Shares
mkdir /mnt/download
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Download /mnt/download
mkdir -p ~/vpnconfig/openvpn/
cp /mnt/download/nl-aes-128-cbc-udp-dns.ovpn ~/vpnconfig/openvpn/
cp /mnt/download/pia_creds.txt ~/vpnconfig/openvpn/

cd docker-builds/qBittorrent-only/
docker-compose up -d