#!/bin/bash

# Remove old dockers Docker
sudo apt-get remove docker docker-engine docker.io containerd runc

# Add repository key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt install -y docker-ce docker-ce-cli
sudo usermod -aG docker ${USER}
#su - ${USER}

#Install docker machine
base=https://github.com/docker/machine/releases/download/v0.16.2 &&
curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
chmod +x /usr/local/bin/docker-machine

return 0