sudo apt update
sudo apt -y upgrade

########## SETUP NAMESERVER START #########
sudo apt install resolvconf

echo 'nameserver 8.8.8.8' | sudo tee -a /etc/resolvconf/resolv.conf.d/head
echo 'nameserver 8.8.4.4' | sudo tee -a /etc/resolvconf/resolv.conf.d/head

sudo systemctl start resolvconf.service
sudo systemctl enable resolvconf.service
sudo systemctl status resolvconf.service
########## SETUP NAMESERVER END #########

sudo systemctl reboot

########## Setup Node START #########
sudo apt -y install curl vim git dnsutils net-tools nmap wget  gnupg2 software-properties-common apt-transport-https ca-certificates 

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# sudo sysctl --system
# make sure that the br_netfilter module is loaded
lsmod | grep br_netfilter
########## Setup Node END #########

########## DOCKER START #########
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt -y autoremove
sudo apt-get update && sudo apt-get install -y containerd.io=1.2.13-2 docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
sudo apt-mark hold docker-ce docker-ce-cli containerd.io
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
########## DOCKER   END #########


########## Install K8s START #########

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt -y install kubelet kubeadm kubectl 
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet
########## Install K8s END #########

########## Setup K8s Start #########
sudo kubeadm config images pull

sudo kubeadm init --pod-network-cidr=192.168.0.50/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-

########## Setup K8s END #########


########## Verify #########
kubectl get nodes
kubeadm token create --print-join-command
#kubectl taint nodes charlie node-role.kubernetes.io/master:NoSchedule-
#kubectl taint nodes delta node-role.kubernetes.io/worker:NoSchedule-
#kubectl taint nodes delta node.kubernetes.io/unreachable:NoExecute-
kubectl describe node charlie | grep Taint
# kubeadm join 192.168.0.27:6443 --token tl4mle.2cplb2lqvkdyfinj --discovery-token-ca-cert-hash sha256:b54d91ee19c68601cc97cdb9b58a21c0bcc67e015af0cae4c207c612004ee6c2 
########## Verify END #########


########## Troubleshoot Start #########
sudo cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
#Set Environment="KUBELET_EXTRA_ARGS=--resolv-conf=/run/systemd/resolve/resolv.conf"
########## Troubleshoot End #########