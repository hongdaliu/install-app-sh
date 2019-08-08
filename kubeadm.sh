#!/bin/bash

# # Kubeadm, kubelet and kubectl install
kubeadm(){
  yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  yum-config-manager \
    --add-repo \
    https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
  
  # Set SELinux in permissive mode (effectively disabling it)
  setenforce 0
  sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

  yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
  systemctl enable --now kubelet
  systemctl daemon-reload
  systemctl restart kubelet
}