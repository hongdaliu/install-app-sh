#!/bin/bash

install(){
  cd /opt
  wget https://www-us.apache.org/dist/hbase/2.0.5/hbase-2.0.5-bin.tar.gz
  if [ -f hbase-2.0.5-bin.tar.gz ]
  then
    tar xzvf hbase-2.0.5-bin.tar.gz
    mkdir -p hbase-2.0.5-bin.tar.gz/data
    echo 'export HBASE_HOME=/opt/hbase-2.0.5' >> ~/.bashrc
    echo 'PATH=$PATH:$HBASE_HOME/bin' >> ~/.bashrc
    source ~/.bashrc
  else
    echo "download zookeeper error!!!"
    exit
  fi
  echo "finished install"
}