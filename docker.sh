#!/bin/bash

# Docker install
docker(){
  yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y docker-ce-18.06.2.ce docker-ce-cli
  systemctl start docker
  systemctl enable docker
}