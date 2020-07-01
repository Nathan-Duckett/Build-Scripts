#!/bin/sh

sudo apt update -qq > /dev/null
sudo apt upgrade -yqq > /dev/null

# Install KVM support
sudo apt-get install \
  qemu-kvm \
  libvirt-daemon-system \
  libvirt-clients \
  bridge-utils -yqq > /dev/null

sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER

# Installing Kimchi
# Copied from https://github.com/kimchi-project/kimchi/releases/tag/3.0.0

# # Install Wok
# wget https://github.com/kimchi-project/wok/releases/download/3.0.0/wok-3.0.0-0.ubuntu.noarch.deb
# sudo apt install -y ./wok-3.0.0-0.ubuntu.noarch.deb

# # Some Kimchi dependencies need to be installed via pip
# sudo apt install -y python3-pip pkg-config libnl-route-3-dev
# sudo -H pip3 install -r https://raw.githubusercontent.com/kimchi-project/kimchi/master/requirements-UBUNTU.txt

# # Install Kimchi
# wget https://github.com/kimchi-project/kimchi/releases/download/3.0.0/kimchi-3.0.0-0.noarch.deb
# sudo apt install -y ./kimchi-3.0.0-0.noarch.deb


# # Cleanup files
# rm *.deb

# Wok dependencies
sudo apt install -y systemd logrotate python3-psutil python3-ldap python3-lxml python3-websockify python3-jsonschema openssl nginx python3-cherrypy3 python3-cheetah python3-pam python-m2crypto gettext python3-openssl