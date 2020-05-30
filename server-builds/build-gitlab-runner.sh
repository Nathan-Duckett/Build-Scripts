#!/bin/sh

# Install required software
sudo apt update -qq
sudo apt upgrade -yqq

sudo apt install openjdk-11-jdk git maven -yqq

bash ../development-builds/install-infer.sh

# Extracted from server_applications/install_gitlab_ci.sh

if [ "$#" -ne 2 ]; then
    echo "Incorrect usage; Should be: build-gitlab-runner.sh <url> <token> <user_pass>"
    exit 1
fi

URL="$1"
TOKEN="$2"

CI_USER="GitlabCI"
CI_PASS="$3"
CI_PWD="/local/scratch/GitlabCI"

# Create CI user account
sudo useradd -d $CI_PWD -s /sbin/nologin -p "$CI_PASS" $CI_USER

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
  --description "Gitlab Runner to execute tasks inside a linux environment." \
  --tag-list "nathan,linux,gui" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"

# Install as a service and start
sudo gitlab-runner install --user "$CI_USER" --working-directory "$CI_PWD"

sudo gitlab-runner start