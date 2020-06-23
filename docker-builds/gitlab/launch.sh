#!/bin/sh

export GITLAB_HOME="~/.gitlab_docker_store/"

# Make if doesn't exist
mkdir -p GITLAB_HOME

docker-compose up -d