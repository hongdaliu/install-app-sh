#!/bin/bash

command="install"
app=""
pid=1
servers=""

help(){
  echo "用法: sh [选项...] [FILE]...\n"
  echo "-c,               执行命令(install, shutdown, restart)\n"
  echo "-a,               操作应用(zookeeper, hdoop, hbase)\n"
}

init(){
  isJavaInstall=`yum list installed | grep java`
  if [ ${#isJavaInstall} == 0 ]
  then
    echo "installing java..."
    yum install -y java
    yum install -y java-1.8.0-openjdk-devel.x86_64
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
    yum install -y npt
  fi
  #download sh files
  wget 
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

echo "begin ${command} ${app}..."
. ./$app.sh
if [ ${command} == "install" ]
then
  init
  install
fi
