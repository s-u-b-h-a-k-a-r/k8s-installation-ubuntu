#!/bin/bash

figlet WORKER

figlet NFS
apt-get install nfs-common

echo "[TASK 1] Join master"
#Update the join token by executing the command on master node
#kubeadm token create --print-join-command
kubeadm join !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!