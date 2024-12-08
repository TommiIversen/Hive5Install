#!/bin/bash

# Opret basemappe
sudo mkdir -p /opt/Hive5Data/Engine
sudo mkdir -p /opt/Hive5Data/StreamHub
# Giv adgang til den aktuelle bruger
sudo chown -R $USER:$USER /opt/Hive5Data


sudo mkdir -p /opt/Hive5Install
sudo chown $USER:$USER /opt/Hive5Install
cd /opt/Hive5Install
git clone https://github.com/TommiIversen/Hive5Install.git .


sudo apt update
sudo apt install docker.io

sudo usermod -aG docker $USER
newgrp docker
