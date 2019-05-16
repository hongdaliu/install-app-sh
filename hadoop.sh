#!/bin/bash

install() {
  cd /opt
  wget https://www-us.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
  if [ -f hadoop-3.1.2.tar.gz ]
  then
    tar -xvf hadoop-3.1.2.tar.gz
    mkdir -p hadoop-3.1.2/data
    echo 'export HADOOP_HOME=/opt/hadoop-3.1.2' >> ~/.bashrc
    echo 'PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> ~/.bashrc
    
    echo 'export HDFS_DATANODE_USER=root' >> ~/.bashrc
    echo 'export HDFS_SECONDARYNAMENODE_USER=root' >> ~/.bashrc
    echo 'export HDFS_NAMENODE_USER=root' >> ~/.bashrc
    
    echo 'export YARN_RESOURCEMANAGER_USER=root' >> ~/.bashrc
    echo 'export YARN_NODEMANAGER_USER=root' >> ~/.bashrc
    echo 'export YARN_PROXYSERVER=root' >> ~/.bashrc
    
    rm -rf hadoop-3.1.2.tar.gz
    rm -rf hadoop-3.1.2/share/doc
    source ~/.bashrc
    
    wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/core-site.xml -O /opt/hadoop-3.1.2/etc/hadoop/core-site.xml
    wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/mapred-site.xml -O /opt/hadoop-3.1.2/etc/hadoop/mapred-site.xml
    wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/hdfs-site.xml -O /opt/hadoop-3.1.2/etc/hadoop/hdfs-site.xml
    wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/workers -O /opt/hadoop-3.1.2/etc/hadoop/workers
  else
    echo "download hadoop error!!!"
    exit
  fi
  echo "finished install"
}
