#!/bin/bash

#Repo de Ansible
apt-add-repository -y ppa:ansible/ansible

#Repo de Influxdb
curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

add-apt-repository -y ppa:chris-lea/redis-server

apt update
apt install -y influxdb influxdb-client adduser libfontconfig redis-server python-simplejson ansible

#Instalacion del Java
add-apt-repository -y ppa:webupd8team/java
apt update
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -y --allow-unauthenticated oracle-java8-installer python-simplejson

systemctl enable influxdb.service
systemctl start influxdb.service
sed -i 's/^bind/\#bind/g' /etc/redis/redis.conf
systemctl restart redis-server.service

#Install chronograf
echo "407d5fe18ebdb525e971d8ddbcbd9b0895c112e8cf562555d93b98e8788679c3  chronograf_1.4.3.0_amd64.deb" >sha256sum.txt
wget 'https://dl.influxdata.com/chronograf/releases/chronograf_1.4.3.0_amd64.deb'
sha256sum  -c sha256sum.txt && dpkg -i chronograf_1.4.3.0_amd64.deb
systemctl enable chronograf

#Install grafana
wget 'https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_5.0.4_amd64.deb' && dpkg -i grafana_5.0.4_amd64.deb
systemctl enable grafana-server.service
systemctl start grafana-server.service

until $(curl --output /dev/null --silent --head --fail localhost:3000/api/health); do
  #echo 'Iniciando grafana ...'
  printf '.'
  sleep 3
done

#Crear db en InfluxDB
curl -G http://localhost:8086/query --data-urlencode "q=CREATE USER admin WITH PASSWORD 'admin123' WITH ALL PRIVILEGES"
curl -G http://localhost:8086/query --data-urlencode "q=CREATE USER jmeter WITH PASSWORD 'jmeter123' WITH ALL PRIVILEGES"
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE jmeter_test"

curl -X POST -H "Content-Type: application/json" -d '
{"name":"jmeter",
"type":"influxdb",
"url":"http://localhost:8086",
"access":"proxy",
"database":"jmeter_test",
"user":"",
"password":""}' http://admin:admin@localhost:3000/api/datasources

curl -i -u admin:admin -H "Content-Type: application/json" -X POST http://localhost:3000/api/dashboards/db -d @/tmp/jmeter-load-test.json

curl -X PUT -H "Content-Type: application/json" -d '
{"oldPassword": "admin",
"newPassword": "admin123",
"confirmNew": "admin123"}' http://admin:admin@localhost:3000/api/user/password

cat /tmp/nodes >> /etc/hosts
echo '
Host *
    StrictHostKeyChecking no
    User ubuntu' > /root/.ssh/config
