#!/bin/bash

sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml


#sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''
#sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''
#sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''
#sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''

#sudo cp /etc/ssh/ssh_host_rsa_key $HOME/.ssh/id_rsa
#sudo cp /etc/ssh/ssh_host_rsa_key $HOME/.ssh/id_rsa.pub
#cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys


# echo "Run sshd service..." 
#sudo /bin/bash -c /usr/sbin/sshd -D

#echo "Formating HDFS..."
#'Y' | hadoop namenode -format

#echo "Starting HDFS..."
#start-dfs.sh

bash