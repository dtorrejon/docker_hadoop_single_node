#!/bin/bash

#RUN ssh-keygen -f id_rsa -t rsa -N ''
#cp /root/.ssh/* /vol/

sed -i s/masternode/`hostname`/g /opt/hadoop-3.2.0/etc/hadoop/core-site.xml

#echo "export JAVA_HOME=/usr/java/jdk-12.0.1/" >> etc/hadoop/hadoop-env.sh
#ssh-keygen -f id_rsa -t rsa -N ''

#echo "does it works?"
#mkdir input
#cp /opt/hadoop-3.2.0/etc/hadoop/*.xml input
#hadoop jar /opt/hadoop-3.2.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar grep input output 'dfs[a-z.]+'
#cat output/*


bash

