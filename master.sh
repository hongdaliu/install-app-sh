#!/bin/bash

yum update
# Java install
yum install -y java-1.8.0-openjdk-devel.x86_64

# Wget install
yum install -y wget

# Ntp install
yum -y install ntp
timedatectl set-timezone Asia/Shanghai
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/ntp.conf -O /etc/ntp.conf
systemctl start ntpd
systemctl enable ntpd

# Docker install
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker

# Kubeadm, kubelet and kubectl install
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

systemctl daemon-reload
systemctl restart kubelet
