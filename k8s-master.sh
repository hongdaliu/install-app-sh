#!/bin/bash

yes | yum update
# Wget install
yum install -y wget

scriptPath="/opt/scripts"
mkdir -p $scriptPath
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/ntp.sh -O "$scriptPath"/ntp.sh
source /$scriptPath"/ntp.sh"
ntp

# Init Setting
systemctl stop firewalld
systemctl disable firewalld
# Close swap
swapoff -a

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

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Docker Install
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/docker.sh -O "$scriptPath"/docker.sh
source /$scriptPath"/docker.sh"
docker

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet