#!/bin/bash
tar xzf /home/ubuntu/apache-jmeter-3.1_slave.tar.gz -C /opt
rm -f /home/ubuntu/apache-jmeter-3.1_slave.tar.gz
cp -r /opt/apache-jmeter-3.1_slave /opt/apache-jmeter-3.1_slave_2
cp -r /opt/apache-jmeter-3.1_slave /opt/apache-jmeter-3.1_slave_3
cp -r /opt/apache-jmeter-3.1_slave /opt/apache-jmeter-3.1_master

sed -ri -e "s/(^server_port=)[0-9]*/\124002/g" -e "s/(client\.rmi\.localport=)[0-9]*/\126001/g" /opt/apache-jmeter-3.1_slave_2/bin/jmeter.properties
sed -ri -e "s/(^server_port=)[0-9]*/\124003/g" -e "s/(client\\.rmi\\.localport=)[0-9]*/\126002/g" /opt/apache-jmeter-3.1_slave_3/bin/jmeter.properties
sed -i  '27i JVM_ARGS="-Xms3072m -Xmx3072m -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:-UseGCOverheadLimit -XX:NewSize=768m -XX:MaxNewSize=768m -XX:-UseParallelGC -XX:+UseGCOverheadLimit -Xss512k"' /opt/apache-jmeter-3.1_master/bin/jmeter.sh

add-apt-repository -y ppa:webupd8team/java
apt-get update
#echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
#echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install -y --allow-unauthenticated oracle-java8-installer python-simplejson
