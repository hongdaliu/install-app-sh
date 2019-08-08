#!/bin/bash

# Ntp install
ntp(){
  yum -y install ntp
  timedatectl set-timezone Asia/Shanghai
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/ntp.conf -O /etc/ntp.conf
  systemctl start ntpd
  systemctl enable ntpd
}