#!/bin/sh
# JMETER_VERSION=${JMETER_VERSION} 
# JMETER_DOWNLOAD_URL=${JMETER_DOWNLOAD_URL}
# JMETER_HOME=${JMETER_HOME}

echo "Installing Java"

# Install Java
yum install java -y

echo "Installing JMeter..."

curl -L --silent ${JMETER_DOWNLOAD_URL} > ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}.tgz
tar -xzf ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}.tgz -C ${JMETER_HOME}
rm -f ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}.tgz

# Leader and follower nodes
if [ "${JMETER_MODE}" = "leader" ]; then
    echo "Configuring JMeter as leader node"
    source ${JMETER_HOME}/.bashrc
    export PRIVATE_IP=$(hostname -I | awk '{print $1}')
    echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment
fi

if [ "${JMETER_MODE}" = "follower" ]; then
    echo "Configuring JMeter as follower node"
    source ${JMETER_HOME}/.bashrc
    export PRIVATE_IP=$(hostname -I | awk '{print $1}')
    echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment
    jmeter -s -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$PRIVATE_IP -j /tmp/jmeter-server.log
fi
