systemctl stop kubelet docker

cd /etc/

# backup old kubernetes data
mv kubernetes kubernetes-backup
mv /var/lib/kubelet /var/lib/kubelet-backup

# restore certificates
mkdir -p kubernetes
cp -r kubernetes-backup/pki kubernetes
rm kubernetes/pki/{apiserver.*,etcd/peer.*}

systemctl start docker

# reinit master with data in etcd
# add --kubernetes-version, --pod-network-cidr and --token options if needed
sudo kubeadm init --control-plane-endpoint=blue.pkvnw --ignore-preflight-errors=DirAvailable--var-lib-etcd

# update kubectl config
cp kubernetes/admin.conf ~/.kube/config

# wait for some time and delete old node
sleep 120
kubectl get nodes --sort-by=.metadata.creationTimestamp
kubectl delete node $(kubectl get nodes -o jsonpath='{.items[?(@.status.conditions[0].status=="Unknown")].metadata.name}')

# check running pods
kubectl get pods --all-namespaces


