#!/bin/bash

# Disable firewalld
systemctl stop firewalld
systemctl disable firewalld

# Init Setting
swapoff -a
sysctl net.bridge.bridge-nf-call-iptables=1
# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yes | yum update
# Docker install
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
  --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce-18.06.2.ce containerd.io
systemctl start docker
systemctl enable docker

# Wget install
yum install -y wget

# Ntp install
yum -y install ntp
timedatectl set-timezone Asia/Shanghai
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/ntp.conf -O /etc/ntp.conf
systemctl start ntpd
systemctl enable ntpd

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

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet
systemctl daemon-reload
systemctl restart kubelet

kubeadm init --pod-network-cidr=10.244.0.0/16
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml