#!/bin/bash
env_test=$(env | grep HADOOP_HDFS_HOME)
if [ "X$env_test" == "X" ]; then
    echo "change user to hadoop user"
    exit
fi
rm -r in
hadoop dfs -rm -r /in /out
mkdir -p in
touch in/file
echo "This is one line" >> in/file
echo "This is another one" >> in/file
hadoop dfs -copyFromLocal in /in
hadoop jar  /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.3.0.jar wordcount /in /out
hadoop dfs -cat /out/*
