kubectl drain charlie --delete-emptydir-data --force --ignore-daemonsets
kubectl drain delta --delete-emptydir-data --force --ignore-daemonsets


iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
ipvsadm -C
kubectl delete node charlie
kubectl delete node delta
kubeadm reset