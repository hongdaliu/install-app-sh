#!/bin/bash

command="install"
app=""
pid=1
servers=""

help(){
  echo "用法: sh [选项...] [FILE]...\n"
  echo "-c,               执行命令(install, shutdown, restart, update)\n"
  echo "-a,               操作应用(zookeeper, hdoop, hbase, firewall)\n"
}

init(){
  isJavaInstall=`yum list installed | grep java`
  if [ ${#isJavaInstall} == 0 ]
  then
    echo "installing java..."
    yum install -y java
    yum install -y java-1.8.0-openjdk-devel.x86_64

    echo 'export JAVA_HOME=/etc/alternatives/java_sdk_1.8.0_openjdk' >> ~/.bashrc
    echo 'export JRE_HOME=${JAVA_HOME}/jre' >> ~/.bashrc
    echo 'export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib' >> ~/.bashrc
    echo 'PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
    source ~/.bashrc
  fi

  isWgetInstall=`yum list installed | grep wget`
  if [ ${#isWgetInstall} == 0 ]
  then
    echo "installing wget..."
    yum install -y wget
  fi
  
  isNtpInstall=`yum list installed | grep npt`
  if [ ${#isNtpInstall} == 0 ]
  then
    echo "installing npt..."
    yum -y install ntp
    systemctl start ntpd
    systemctl enable ntpd
  fi
  #download sh files
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/zookeeper.sh
  sleep 1s
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/firewall.sh
  sleep 1s
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/hadoop.sh
  sleep 1s
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/hbase.sh
  sleep 1s
}

while getopts "c:a:" opt
do
  case $opt in
    c)
      command=${OPTARG}
      ;;
    a)
      app=${OPTARG}
      ;;
    *)
      help
      exit
      ;;
  esac
done

if [ ${command} == "init" ]
then
  init
  echo "finished init"
  exit
fi

. ./${app}.sh
if [ ${command} == "install" ]
then
  init
  install
fi

if [ ${command} == "update" ]
then
  firewall
fi
sleep 3s
. ./firewall.sh
firewall
echo "end!!"
rm -rf zookeeper.sh
rm -rf firewall.sh
rm -rf hadoop.sh
#rm -rf hbase.sh
