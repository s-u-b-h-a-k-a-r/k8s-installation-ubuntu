#!/bin/bash

figlet MASTER

echo "[TASK 1] Start master"
kubeadm init --ignore-preflight-errors all --pod-network-cidr=10.244.0.0/16 --token-ttl 0

echo "[TASK 2] Install kubeconfig and additional network components"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
echo 'export KUBECONFIG=$HOME/.kube/config' >> $HOME/.bashrc
echo "export kubever=$(kubectl version | base64 | tr -d '\n')" >> $HOME/.bashrc
export KUBECONFIG=$HOME/.kube/config
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
systemctl restart docker && systemctl restart kubelet

echo "[TASK 3] Install Calico"
kubectl apply -f https://docs.projectcalico.org/v3.0/getting-started/kubernetes/installation/hosted/kubeadm/1.7/calico.yaml 

echo "[TASK 4] Display PODS"
kubectl get pods --all-namespaces

echo "[TASK 5] Install Dashboard"
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard-rbac.yaml

echo "[TASK 6] Display All Services"
kubectl get services -n kube-system 


echo "[TASK 7] Setup NFS"
figlet NFS
apt-get install -y nfs-kernel-server
apt-get install -y nfs-common

mkdir -p /mnt/storage
cat >>/etc/hosts<<EOF
/mnt/storage *(rw,sync,no_root_squash,no_subtree_check)
EOF
systemctl restart nfs-kernel-server
exportfs -a
