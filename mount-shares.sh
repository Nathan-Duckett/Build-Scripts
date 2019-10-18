#!/bin/bash
NETWORK_SHARE_IP=192.168.1.39
SMB_SHARE_USERNAME=natha

# Mount SMB Network Shares
mkdir /mnt/videos
mount -t cifs -o user=$SMB_SHARE_USERNAME //$NETWORK_SHARE_IP/Videos /mnt/videos