#!/bin/sh

if [ "$#" -ne 4 ]; then
    echo "Incorrect usage; Should be: install_gitlab_ci.sh <url> <token> <PAT> <Project_ID>"
    exit 1
fi

URL="$1"
TOKEN="$2"
PAT="$3"
PROJECT_ID="$4"

# Update and prepare

sudo apt update && sudo apt upgrade -y

sudo apt install openjdk-11-jdk maven git curl htop python3-pip -y

# Workaround to require no ssl on git repos
git config --global http.sslverify false

CI_PWD="$HOME/GitlabCI"

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
  --description "$USER-$HOSTNAME Gitlab CI Runner" \
  --tag-list "$USER,linux" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"

# Install as a service and start
sudo gitlab-runner uninstall
sudo gitlab-runner install --user "$USER" --working-directory "$CI_PWD"

sudo gitlab-runner start

# Restart just in case didn't correctly register.
sudo gitlab-runner restart


# Cronjob of management tools
# GitlabTimeCounter from Tim Salisbury for counting up all time spent
git clone https://github.com/TimSalisbury/GitlabTimeCounter
mv GitlabTimeCounter $HOME/GitlabTimeCounter
cat << EOF > $HOME/GitlabTimeCounter/config.ini
[AUTHENTICATION]
GitLabServer = https://gitlab.ecs.vuw.ac.nz
PersonalAccessToken = $PAT

[PROJECT]
ID = $PROJECT_ID
SprintMilestonePrefix = Sprint
LabTimeWikiSlug = Lab-time-log
EOF

# Gitlab-Pair-Programming to construct programming matricies into the wiki
git clone https://github.com/Nathan-Duckett/Gitlab-Pair-Programming.git
mv Gitlab-Pair-Programming $HOME/Gitlab-Pair-Programming
cat << EOF > $HOME/Gitlab-Pair-Programming/config.yaml
rootURI: https://gitlab.ecs.vuw.ac.nz/api/v4/
PAT: $PAT
projectID: $PROJECT_ID
EOF

# Gitlab-Wiki-Uploader to post this information into the wiki
git clone https://github.com/Nathan-Duckett/Gitlab-Wiki-Updater.git
mv Gitlab-Wiki-Updater $HOME/Gitlab-Wiki-Updater
cat << EOF > $HOME/Gitlab-Wiki-Updater/config.yaml
rootURI: https://gitlab.ecs.vuw.ac.nz
PAT: $PAT
projectID: $PROJECT_ID
wikiSlug: Time-Tracking-by-Team-Member
EOF

# Install dependencies
pip3 install -r $HOME/GitlabTimeCounter/requirements.txt
pip3 install -r $HOME/Gitlab-Pair-Programming/requirements.txt
pip3 install -r $HOME/Gitlab-Wiki-Updater/requirements.txt

# https://stackoverflow.com/questions/4880290/how-do-i-create-a-crontab-through-a-script
# Set to run at midnight nightly
(crontab -l 2>/dev/null; echo "0 0 * * * python3 $HOME/GitlabTimeCounter/TimeCounter.py | python3 $HOME/Gitlab-Wiki-Updater/upload.py") | crontab -
(crontab -l 2>/dev/null; echo "0 0 * * * python3 $HOME/Gitlab-Pair-Programming/track_pairs.py | python3 $HOME/Gitlab-Wiki-Updater/upload.py -s Pair-Programming-Matrix") | crontab -

# Run upload lab times now
python3 $HOME/GitlabTimeCounter/TimeCounter.py | python3 $HOME/Gitlab-Wiki-Updater/upload.py

# Run upload pair programming matrix now
python3 $HOME/Gitlab-Pair-Programming/track_pairs.py | python3 $HOME/Gitlab-Wiki-Updater/upload.py -s Pair-Programming-Matrix