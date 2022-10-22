#!/bin/bash
#Instalacion de consul 
echo "Instalando el consul "
sudo wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install consul -y
#Creo directorios
sudo mkdir -p /etc/consul.d/scripts

sudo mkdir /var/consul

#Llave password
 echo sudo consul keygen
key=$(sudo consul keygen)

echo "$key"
#Muevo el file al config.json
sudo mv /home/vagrant/config_server.json /etc/consul.d/config.json

#Reemplazo la llave 
sudo sed -i "s|\"encrypt\"\:\ \".*\"|\"encrypt\"\:\ \"$key\"|g" /etc/consul.d/config.json
echo "Se modifico la llave"

echo "Genero la copia"
sudo cp -v /etc/consul.d/config.json /vagrant/config_1.json

key=192.168.100.11
echo "actualizo la ip"

echo "$key"
sudo sed -i "s|IP|$key|g" /etc/consul.d/config.json

#Inicio mi servicio
sudo mv /home/vagrant/consul_server.service /etc/systemd/system/consul.service

sudo systemctl daemon-reload

sudo systemctl enable consul

sudo systemctl start consul

sudo systemctl restart consul


echo "Instalando el haproxy"

sudo apt install haproxy -y

sudo mv /home/vagrant/haproxy.cfg /etc/haproxy/haproxy.cfg

echo "Personalizo mi pagina de error"

sudo cp --force /home/vagrant/503.http /etc/haproxy/errors/

sudo systemctl enable haproxy

sudo systemctl start haproxy

sudo systemctl restart haproxy

#Artillery 
echo "instalacion artillery"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt-get update nodejs -y
sudo apt install npm -y
sudo npm update -y
sudo npm install -g n -y
sudo n stable
sudo npm install -g artillery@latest -y
 

