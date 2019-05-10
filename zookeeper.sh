#!/bin/bash

install(){
  cd /opt
  wget https://www-us.apache.org/dist/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz
  if [ -f zookeeper-3.4.14.tar.gz ]
  then
    tar -xvf zookeeper-3.4.14.tar.gz
  else
    echo "download zookeeper error!!!"
    exit
  fi

}