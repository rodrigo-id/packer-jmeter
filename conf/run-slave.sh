#!/bin/bash
cd /opt/apache-jmeter-3.1_slave/bin
./jmeter-server -Djava.rmi.server.hostname=127.0.1.1 -p jmeter.properties &
cd /opt/apache-jmeter-3.1_slave_2/bin
./jmeter-server -Djava.rmi.server.hostname=127.0.1.1 -p jmeter.properties &
cd /opt/apache-jmeter-3.1_slave_3/bin
./jmeter-server -Djava.rmi.server.hostname=127.0.1.1 -p jmeter.properties &
