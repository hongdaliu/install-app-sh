#!/bin/bash

type="slave"
while getopts "t:" opt
do
  case $opt in
    t)
      type=${OPTARG}
      ;;
    *)
      echo "please input right command!"
      exit
      ;;
  esac
done
echo "-------------------------------------------------"
echo "| begin exectue "$type"                         |"
echo "-------------------------------------------------"

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
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/fstab -O /etc/fstab

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
sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sysctl --system

# Docker Install
mkdir /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/docker.sh -O "$scriptPath"/docker.sh
source /$scriptPath"/docker.sh"
docker

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

if [ ${type} == "master" ]
then
  kubeadm init --pod-network-cidr=10.244.0.0/16
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  # Flannel
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
  sleep 10s
  # Dashboard
  wget https://raw.githubusercontent.com/hongdaliu/install-app-sh/master/conf/dashboard.yaml -O "$scriptPath"/dashboard.yaml
  kubectl apply -f "$scriptPath"/dashboard.yaml
  kubectl create serviceaccount dashboard-admin -n kube-system
  kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin
  kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $l}')
fi

rm -rf $scriptPath