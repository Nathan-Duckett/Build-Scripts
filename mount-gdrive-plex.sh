#!/bin/bash

if [ $EUID != 0 ]; then
    echo "Script must be run as root user"
    exit 1
fi

apt install fuse -qq

cd
wget https://github.com/dweidenfeld/plexdrive/releases/download/5.0.0/plexdrive-linux-amd64
mv plexdrive-linux-amd64 plexdrive
mv plexdrive /usr/bin/
chown root:root /usr/bin/plexdrive
chmod 755 /usr/bin/plexdrive
mkdir /mnt/gdrive

#Run manually to setup connections to follow the prompts
echo "When credentials are added you must CTRL^C out to stop application"
plexdrive mount -c /root/.plexdrive -o allow_other /mnt/gdrive

cat > /lib/systemd/system/plexdrive.service << EOF
[Unit]
Description=Plexdrive
AssertPathIsDirectory=/mnt/gdrive
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/plexdrive -o allow_other -v 2 --max-chunks=50 mount /mnt/gdrive/
ExecStop=/bin/fusermount -uz /mnt/gdrive
Restart=on-abort

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl start plexdrive.service
systemctl enable plexdrive.service