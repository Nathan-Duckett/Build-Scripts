#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Incorrect usage; Should be: install_gitlab_ci.sh <url> <token>"
    exit 1
fi

URL="$1"
TOKEN="$2"

CI_USER="GitlabCI"
CI_PASS="$(secrethub read nduckett13/gitlabCI/password)"
CI_PWD="/mnt/mini/scratch/GitlabCI"

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
  --description "[Anton] Gitlab shell runner to execute on server" \
  --tag-list "shell,java,python" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"

# Install as a service and start
sudo gitlab-runner install --user "$CI_USER" --working-directory "$CI_PWD"

sudo gitlab-runner start