#!/bin/bash

#Configure de hostname wihin the xml hadoop congfig files
sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml
sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/yarn-site.xml

echo "Running sshd service..."
sudo /bin/bash -c /usr/sbin/sshd -D

echo "Configuring SSH Keys..."
ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub -f `hostname`
ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub -f localhost

echo "starting hadoop..."
/opt/hadoop-3.2.0/sbin/start-all.sh

bash
