#!/bin/bash

# Opret basemappe
sudo mkdir -p /opt/Hive5Data/Engine
sudo mkdir -p /opt/Hive5Data/StreamHub
# Giv adgang til den aktuelle bruger
sudo chown -R $USER:$USER /opt/Hive5Data


# Opdater systemets pakkeindeks
sudo apt update

# Installer nødvendige pakker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Tilføj Docker's officielle GPG-nøgle
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Tilføj Docker's repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Opdater pakkeindeks igen efter at have tilføjet Docker's repository
sudo apt update

# Installer Docker
sudo apt install -y docker-ce

# Gør det muligt for din bruger at køre Docker-kommandoer (erstat 'username' med dit eget brugernavn)
sudo groupadd docker
sudo usermod -aG docker ${USER}
newgrp docker

# Installer Docker Compose
# Hent den nyeste version af Docker Compose (erstat '1.29.2' med den ønskede version)
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

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
