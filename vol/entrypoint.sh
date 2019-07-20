#!/bin/bash

sed -i s/localhost/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml

echo "generating SSH keys..."
sleep 1
sudo ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N '' 
sudo ssh-keygen -f /etc/ssh/ssh_host_dsa_key -t dsa -N '' 
sudo ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa -N '' 
sudo ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -t ed25519 -N '' 
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N '' 
echo "Adding ton known hosts..."
sleep 1
cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/authorized_keys
cp $HOME/.ssh/id_rsa.pub $HOME/.ssh/known_hosts


echo "Running sshd service..."
sleep 1 
sudo /bin/bash -c /usr/sbin/sshd -D
sleep 1

echo "Configuring SSH AutoConnection..."
sleep 1
ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub -f `hostname`
ssh-copy-id -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa.pub -f localhost

echo "runnig atd..."
sudo /bin/bash -c /usr/sbin/atd -D
echo "ping -c 4 www.google.com" | at  now + 3 seconds

bash
