#!/usr/bin/env bash
# Script Name: Setup Java Dev
# Author: Nathan Duckett
# Description: Basic script to setup dependencies and intelliJ for Java development
#
# Version History
# Author        Version     Description
# Nathan        1.0         Initial Version to deploy

# IntelliJ version to be installed
INTELLIJ_VERSION="2020.3.3"
INTELLIJ_TAR_FILE="ideaIC-$INTELLIJ_VERSION.tar.gz"

# Set the installation location for IntelliJ
INSTALLATION_LOCATION="$HOME/.apps/idea"

# Pull the specified version of intellij from the Jetbrains site
wget -q "https://download.jetbrains.com/idea/$INTELLIJ_TAR_FILE"

# Extract the application out
# Using https://askubuntu.com/a/470266 for strip-components to ignore Idea folder name within
mkdir -p "$INSTALLATION_LOCATION"
tar -xvf "$INTELLIJ_TAR_FILE" --directory "$INSTALLATION_LOCATION" --strip-components=1

# Clean up tar file
rm "$INTELLIJ_TAR_FILE"

# Check if the aliases file doesn't exist and create it
if [[ ! -f "$HOME/.aliases" ]]; then
  touch "$HOME/.aliases"
  echo "source $HOME/.aliases" >> "$HOME/.bashrc"
  echo "source $HOME/.aliases" >> "$HOME/.zshrc"
fi

# Add the alias to launch intellij
echo "alias idea=\"$INSTALLATION_LOCATION/bin/idea.sh\"" >> "$HOME/.aliases"

# Launch intellij for configuration - script finishes on closure
"$INSTALLATION_LOCATION"/bin/idea.sh