#!/bin/bash

install(){
  cd /opt
  wget https://www-us.apache.org/dist/hbase/2.0.5/hbase-2.0.5-bin.tar.gz
  if [ -f hbase-2.0.5-bin.tar.gz ]
  then
    tar xzvf hbase-2.0.5-bin.tar.gz
    mkdir -p hbase-2.0.5/data
    echo 'export HBASE_HOME=/opt/hbase-2.0.5' >> ~/.bashrc
    echo 'PATH=$PATH:$HBASE_HOME/bin' >> ~/.bashrc
    
    rm -rf hbase-2.0.5-bin.tar.gz
    rm -rf hbase-2.0.5/docs
    source ~/.bashrc
    
    wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/hbase-site.xml -O /opt/hbase-2.0.5/conf/hbase-site.xml
    wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/regionservers -O /opt/hbase-2.0.5/conf/regionservers
  else
    echo "download hbase error!!!"
    exit
  fi
  echo "finished install"
}
