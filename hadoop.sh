#!/bin/bash

install(){
  cd /opt
  wget http://mirrors.shu.edu.cn/apache/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
  if [ -f hadoop-3.1.2.tar.gz ]
  then
    tar -xvf hadoop-3.1.2.tar.gz
    mkdir -p hadoop-3.1.2/data
    echo 'export HADOOP_HOME=/opt/hadoop-3.1.2' >> ~/.bashrc
    echo 'PATH=$PATH:$HADOOP_HOME/bin' >> ~/.bashrc
    source ~/.bashrc
  else
    echo "download hadoop error!!!"
    exit
  fi
  echo "finished install"
}
