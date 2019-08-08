#!/bin/bash

# Docker Containerd install
containerd(){
  modprobe overlay
  modprobe br_netfilter

  # Setup required sysctl params, these persist across reboots.
  cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
  net.bridge.bridge-nf-call-iptables  = 1
  net.ipv4.ip_forward                 = 1
  net.bridge.bridge-nf-call-ip6tables = 1
EOF
  sysctl --system

  yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y containerd.io
  # Configure containerd
  mkdir -p /etc/containerd
  containerd config default > /etc/containerd/config.toml

  # Restart containerd
  systemctl restart containerd
  systemctl enable containerd
}