#!/bin/bash

install(){
  cd /opt
  wget https://www-us.apache.org/dist/kafka/2.2.0/kafka_2.12-2.2.0.tgz
  if [ -f kafka_2.12-2.2.0.tgz ]
  then
    tar -xzf kafka_2.12-2.2.0.tgz
    mkdir -p kafka_2.12-2.2.0/data
    echo 'export KAFKA_HOME=/opt/kafka_2.12-2.2.0' >> ~/.bashrc
    echo 'PATH=$PATH:$KAFKA_HOME/bin' >> ~/.bashrc

    rm -rf kafka_2.12-2.2.0.tgz
    wget -P /opt/kafka_2.12-2.2.0/config/ https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/server.properties -O server.properties
    # mv zoo_sample.cfg zoo.cfg
  else
    echo "download zookeeper error!!!"
    exit
  fi
  echo "finished install"
  source ~/.bashrc

  bin/kafka-server-start.sh  -daemon config/server.properties
}
