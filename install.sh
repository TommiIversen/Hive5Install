#!/bin/bash

# Create base directories
mkdir -p /opt/Hive5Data/Engine
mkdir -p /opt/Hive5Data/StreamHub
# Make logged in user owner
chown -R $USER:$USER /opt/Hive5Data


# Update packages
sudo apt update

# Install required packages
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Uninstall old Docker installation
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# Add Dockers official GPG Key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Dockers repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update packages
sudo apt update

# Install Docker
sudo apt install -y docker-ce

# Manage Docker as a non-root user
#sudo groupadd docker
#echo "Add user docker group"
#sudo usermod -aG docker ${USER}
#echo "create new docker group"
#su - ${USER} -c "newgrp docker"

# Install latest Docker Compose version
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Gør Docker Compose eksekverbar
sudo chmod +x /usr/local/bin/docker-compose

# Konfigurer NVIDIA Container Toolkit repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Opdater pakkeindeks efter tilføjelse af NVIDIA repository
sudo apt-get update

# Installer NVIDIA Container Toolkit
sudo apt-get install -y nvidia-container-toolkit

# Konfigurer Docker til at bruge NVIDIA Container Runtime
sudo nvidia-ctk runtime configure --runtime=docker

# Genstart Docker daemon
sudo systemctl restart docker



# Installer kernel headers
sudo apt-get install -y linux-headers-$(uname -r)

# Installer CUDA repository public GPG key
distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb

# Opdater APT repository cache og installer CUDA drivers
sudo apt-get update
sudo apt-get -y install cuda-drivers
