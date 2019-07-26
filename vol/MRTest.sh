#!/bin/bash


hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/hadoop
hdfs dfs -mkdir input
hdfs dfs -put /opt/hadoop-3.2.0/etc/hadoop/*.xml input

echo "launching program. Please, wait..."
hadoop jar /opt/hadoop-3.2.0/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.2.0.jar grep input output 'dfs[a-z.]+'
hdfs dfs -get output output
cat output/*


