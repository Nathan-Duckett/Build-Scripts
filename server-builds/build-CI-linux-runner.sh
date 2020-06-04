#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Incorrect usage; Should be: install_gitlab_ci.sh <url> <token>"
    exit 1
fi

URL="$1"
TOKEN="$2"

# Update and prepare

sudo apt update && sudo apt upgrade -y

sudo apt install openjdk-11-jdk maven -y

CI_PWD="/home/nathan/GitlabCI"

# Ensure CI_PWD exists
mkdir -p $CI_PWD

# Install gitlab CI runner
curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
sudo dpkg -i gitlab-runner_amd64.deb
rm gitlab-runner_amd64.deb

# Register the runner
sudo gitlab-runner register \
  --non-interactive \
  --url "$URL" \
  --registration-token "$TOKEN" \
  --executor "shell" \
  --description "Nathan-Server GitlabCI Kubuntu20.04 runner with KDE" \
  --tag-list "nathan,linux" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"

# Install as a service and start
sudo gitlab-runner install --user "nathan" --working-directory "$CI_PWD"

sudo gitlab-runner start
