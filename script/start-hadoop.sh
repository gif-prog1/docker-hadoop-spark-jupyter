#!/bin/bash

# Start SSH server 
/etc/init.d/ssh start

# Checking for Namenode is formatted or not!
if [ -f  /opt/hadoop/data/hdfs/namenode/current/VERSION ]
then
    echo 'Namenode is already formatted!!'
else
    $HADOOP_HOME/bin/hdfs namenode -format
fi

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
$LIVY_HOME/bin/livy-server start
jupyter notebook

tail -f /dev/null