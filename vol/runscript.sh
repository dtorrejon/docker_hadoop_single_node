#!/bin/bash

sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml

#sudo sed -i s/5f4c84ba076a/`hostname`/g /home/hadoop/.ssh/authorized_keys
#sudo sed -i s/5f4c84ba076a/`hostname`/g /home/hadoop/.ssh/known_hosts
#sudo sed -i s/172.17.0.2/`hostname -i`/g /home/hadoop/.ssh/known_hosts
#sudo sed -i s/5f4c84ba076a/`hostname`/g /home/hadoop/.ssh/id_rsa.pub

#sudo sed -i s/5f4c84ba076a/`hostname`/g /etc/ssh/ssh_host_dsa_key.pub
#sudo sed -i s/5f4c84ba076a/`hostname`/g /etc/ssh/ssh_host_ecdsa_key.pub
#sudo sed -i s/5f4c84ba076a/`hostname`/g /etc/ssh/ssh_host_ed25519_key.pub
#sudo sed -i s/5f4c84ba076a/`hostname`/g /etc/ssh/ssh_host_rsa_key.pub

#echo "generating keys..."
sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''
sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N ''
sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N ''
sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N ''
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''


#ssh -o StrictHostKeyChecking=no `hostname`



cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys
cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/known_hosts


#ssh-keyscan -H localhost >> $HOME/.ssh/known_hosts
#ssh-keyscan -H `hostname` >> $HOME/.ssh/known_hosts

#echo "Run sshd service..." 
#sudo /bin/bash -c /usr/sbin/sshd -D
#sleep 2
#ssh -o StrictHostKeyChecking=no `hostname`
#sleep 2

#ssh -o StrictHostKeyChecking=no localhost
#sleep 2


#echo "Formating HDFS..."
#'Y' | hdfs namenode -format
#sleep 10
#echo "Starting HDFS..."
#start-dfs.sh
#sleep 10
#jps

bash
