

sudo chmod -R 775 /opt/Hive5Data
sudo chown -R $USER:$USER /opt/Hive5Data


sudo mkdir -p /opt/Hive5Install
sudo chown $USER:$USER /opt/Hive5Install
cd /opt/Hive5Install
git clone https://github.com/TommiIversen/Hive5Install.git .



git pull
docker compose pull
docker compose up