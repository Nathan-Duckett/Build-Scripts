#!/usr/bin/env bash
# Script Name: Google Chrome Installation
# Author: Nathan Duckett
# Description: Download and install google-chrome
#
# Version History
# Author        Version     Description
# Nathan        1.0         Initial Version to deploy

PACKAGE_NAME="google-chrome-stable_current_amd64.deb"

wget -q "https://dl.google.com/linux/direct/$PACKAGE_NAME"

sudo apt install "./$PACKAGE_NAME" -yqq

rm "$PACKAGE_NAME"