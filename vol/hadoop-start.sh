#!/bin/bash

echo "Formating HDFS..."
sleep 2
hdfs namenode -format
sleep 2
echo "Starting HDFS..."
sleep 2
start-all.sh
echo "Pocess checkout..."
sleep 2
jps
