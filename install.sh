#!/bin/bash

# Create base directories
mkdir -p /opt/Hive5Data/Engine
mkdir -p /opt/Hive5Data/StreamHub
# Make logged in user owner
sudo chown -R $USER:$USER /opt/Hive5Data



# Update packages
sudo apt update

# Install required packages
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Uninstall old Docker installation
# sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras


echo "INSTALLING DOCKER"
# Add Dockers official GPG Key
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Dockers repository to Apt sources
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker and required packages
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Manage Docker as a non-root user
sudo groupadd docker
#echo "Add user docker group"
sudo usermod -aG docker ${USER}
#echo "Create new docker group"
# newgrp docker


echo "INSTALLING DOCKER COMPOSE"
# Install latest Docker Compose version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make Docker Compose executeable
sudo chmod +x /usr/local/bin/docker-compose


echo "INSTALLING NVIDIA CONTAINER TOOLKIT"
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#linux-distributions
# Configure the production repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Update packages
sudo apt-get update

# Install the NVIDIA Container Toolkit packages
sudo apt-get install -y nvidia-container-toolkit


# Configure the container runtime by using the nvidia-ctk command
sudo nvidia-ctk runtime configure --runtime=docker

# Restart the Docker daemon
sudo systemctl restart docker


# Install kernel headers
sudo apt-get install -y linux-headers-$(uname -r)
sudo apt-get update


echo "ISNTALLING CUDA TOOLKIT"
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=24.04&target_type=deb_network
# Install CUDA Toolkit installer
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-6

# Install open kernel module / Driver
sudo apt-get install -y nvidia-open
