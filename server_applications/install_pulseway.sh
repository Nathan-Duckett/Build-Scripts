#!/bin/sh

wget http://www.pulseway.com/download/pulseway_x64.deb

sudo apt install ./pulseway_x64.deb -y

rm pulseway_x64.deb

sudo cp /etc/pulseway/config.xml.sample /etc/pulseway/config.xml

sudo service pulseway start

# Blocking command to register the server
sudo pulseway-registration