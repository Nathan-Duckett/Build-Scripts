#!/bin/sh

URL=""
TOKEN=""

curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
sudo dpkg -i gitlab-runner_amd64.deb

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