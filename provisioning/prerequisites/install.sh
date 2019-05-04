#!/bin/bash
apt-get update -y
apt-get install figlet -y

figlet PREREQUISITES

echo "[TASK 1] Add hosts to etc/hosts"
cat >>/etc/hosts<<EOF
100.10.10.100 k8s-master
100.10.10.101 k8s-worker-1
100.10.10.102 k8s-worker-2
100.10.10.103 k8s-worker-3
EOF

echo "[TASK 2] Disable Swap"
swapoff -a && sed -i '/swap/d' /etc/fstab

echo "[TASK 3] openssh-server"
apt-get install openssh-server -y

echo "[TASK 4] Install Docker"
apt-get install -y docker.io
apt-get update && apt-get install -y apt-transport-https curl

echo "[TASK 5] Add Kubernetes Repositories"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

echo "[TASK 6] Install kubelet/kubeadm/kubectl"
apt-get update -y
apt-get install -y kubelet kubeadm kubectl 
sed -i 's/cgroup-driver=systemd/cgroup-driver=cgroupfs/g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
