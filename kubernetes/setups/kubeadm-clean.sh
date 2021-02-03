# on MASTER
kubectl delete -f https://docs.projectcalico.org/manifests/calico.yaml

sudo kubectl drain charlie --delete-emptydir-data --force --ignore-daemonsets
sudo kubectl drain delta --delete-emptydir-data --force --ignore-daemonsets

sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

sudo kubectl delete node charlie
sudo kubectl delete node delta

# + WORKER
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
sudo ipvsadm -C
sudo kubeadm reset
sudo rm $HOME/.kube/config /etc/kubernetes/admin.conf
sudo rm -rf ~/.kube

sudo apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*   


sudo systemctl disable docker
sudo systemctl stop docker

sudo rm /etc/docker/daemon.json
sudo rm -r /etc/systemd/system/docker.service.d

sudo apt-get purge docker-ce docker-ce-cli containerd.io 
sudo rm -rf /var/lib/docker


sudo apt-get purge -y resolvconf

sudo apt -y autoremove
sudo rm /etc/sysctl.d/kubernetes.conf
sudo systemctl reboot