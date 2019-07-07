#!/bin/bash

echo "Formating HDFS..."
#'Y' | hadoop namenode -format
hdfs namenode -format
sleep 5
echo "Starting HDFS..."
sleep 1
start-dfs.sh
jps
