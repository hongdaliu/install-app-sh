#!/bin/bash

install(){
  cd /opt
  wget https://www-us.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz
  if [ -f zookeeper-3.4.14.tar.gz ]
  then
    tar -xvf zookeeper-3.4.14.tar.gz
    mkdir -p zookeeper-3.4.14/data
    echo 'export ZOOKEEPER_HOME=/opt/software/zookeeper-3.4.14' >> ~/.bashrc
    echo 'PATH=$PATH:$ZOOKEEPER_HOME/bin' >> ~/.bashrc
    source ~/.bashrc
    touch /opt/zookeeper-3.4.14/data/myid
  else
    echo "download zookeeper error!!!"
    exit
  fi
  echo "finished install"
}