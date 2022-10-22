#!/bin/bash

echo "Instalando el consul "
sudo wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

sudo echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install consul -y

#Creo directorios
sudo mkdir -p /etc/consul.d/scripts
sudo mkdir /var/consul

# seteo el config.json
sudo mv /home/vagrant/config_1.json /etc/consul.d/config.json

#Reemplazo la ip_bind 
IP=192.168.100.21
echo "$IP"
echo "actualizo la ip"
sudo sed -i "s|IP|$IP|g" /etc/consul.d/config.json
echo "Se actualizo la ip"

#Inicio mi servicio
echo "iniciando servicio"
sudo mv /home/vagrant/consul_server.service /etc/systemd/system/consul.service

sudo systemctl daemon-reload

sudo systemctl enable consul

sudo systemctl start consul

sudo systemctl restart consul


echo "Instalando nodejs y npm"

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -


sudo apt install nodejs -y
sudo apt install npm -y

sudo git clone https://github.com/omondragon/consulService

sudo mv /home/vagrant/index_1.js /home/vagrant/consulService/app/index.js

sudo cd -v ~ /consulService/app/index.js ./index.js
sudo npm init 
sudo npm install consul -y
sudo npm install express -y

#Inicio mi servicio
echo "iniciando servicio node"
sudo mv /home/vagrant/node_1.service /etc/systemd/system/node.service

sudo systemctl daemon-reload

sudo systemctl enable node

sudo systemctl start node

sudo systemctl restart node