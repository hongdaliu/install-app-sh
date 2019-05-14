#!/bin/bash

install(){
  cd /opt
  wget https://www-us.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz
  if [ -f zookeeper-3.4.14.tar.gz ]
  then
    tar -xvf zookeeper-3.4.14.tar.gz
    mkdir -p zookeeper-3.4.14/data
    echo 'export ZOOKEEPER_HOME=/opt/zookeeper-3.4.14' >> ~/.bashrc
    echo 'PATH=$PATH:$ZOOKEEPER_HOME/bin' >> ~/.bashrc
    
    touch /opt/zookeeper-3.4.14/data/myid
    rm -rf zookeeper-3.4.14.tar.gz
    rm -rf zookeeper-3.4.14/zookeeper-docs/

    wget -P /opt/zookeeper-3.4.14/conf/ https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/zoo.cfg
    # mv zoo_sample.cfg zoo.cfg
  else
    echo "download zookeeper error!!!"
    exit
  fi
  source ~/.bashrc
  echo "finished install"
}
