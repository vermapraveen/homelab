# on MASTER
kubectl delete -f https://docs.projectcalico.org/manifests/calico.yaml

    kubectl drain charlie --delete-emptydir-data --force --ignore-daemonsets

kubectl drain delta --delete-emptydir-data --force --ignore-daemonsets

iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

kubectl delete node charlie

kubectl delete node delta

# + WORKER
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
kubeadm reset
rm $HOME/.kube/config /etc/kubernetes/admin.conf
rm -rf ~/.kube

apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*   


systemctl disable docker
systemctl stop docker

rm /etc/docker/daemon.json
rm -r /etc/systemd/system/docker.service.d

apt-get purge docker-ce docker-ce-cli containerd.io 
rm -rf /var/lib/docker


apt-get purge -y resolvconf

apt -y autoremove
rm /etc/sysctl.d/kubernetes.conf

sudo route del -net 10.10.0.0 dev docker0

systemctl reboot
