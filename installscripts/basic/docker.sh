#!/bin/bash

# Remove old dockers Docker
sudo apt-get remove docker docker-engine docker.io containerd runc

# Get Installation script
curl -fsSL https://get.docker.com -o get-docker.sh

# Install
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker ${USER}

return 0