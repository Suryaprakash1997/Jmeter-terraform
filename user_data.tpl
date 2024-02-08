#!/bin/bash
sudo apt update
sudo apt install openjdk-11-jdk -y
sudo wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz
sudo tar -xzf apache-jmeter-5.6.3.tgz
sudo rm apache-jmeter-5.6.3.tgz
echo 'client.rmi.localport=50000' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
echo 'server.rmi.localport=4000' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
echo 'server.rmi.ssl.disable=true' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
sudo sed -i '268s/.*/remote_hosts=${all_worker_ips}/' /apache-jmeter-5.6.3/bin/jmeter.properties
