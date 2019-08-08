#!/bin/bash

# Init Setting
systemctl stop firewalld
systemctl disable firewalld
# Close swap
swapoff -a

yes | yum update
# Wget install
yum install -y wget

path="/opt/script/"
mkdir -p path



sysctl net.bridge.bridge-nf-call-iptables=1

kubeadm init --pod-network-cidr=10.244.0.0/16
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml