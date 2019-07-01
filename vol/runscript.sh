#!/bin/bash

sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml

echo "generating keys..."
sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''
sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''
sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''
sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''
if [ ! -f $HOME/.ssh/id_rsa ]{
    ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''
}

cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys
cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/known_hosts


ssh-keyscan -H localhost >> $HOME/.ssh/known_hosts
ssh-keyscan -H `hostname` >> $HOME/.ssh/known_hosts

#echo "Run sshd service..." 
#sudo /bin/bash -c /usr/sbin/sshd -D

#echo "Formating HDFS..."
#'Y' | hadoop namenode -format
#sleep 10
#echo "Starting HDFS..."
#start-dfs.sh
sleep 15
#jps

bash
