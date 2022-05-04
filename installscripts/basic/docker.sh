#!/bin/bash

# Remove old dockers Docker
sudo apt-get remove docker docker-engine docker.io containerd runc

# Get Installation script
curl -fsSL https://get.docker.com -o get-docker.sh

# Install
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker ${USER}

# Download docker-compose
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
DESTINATION=/usr/local/bin/docker-compose

sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION

return 0