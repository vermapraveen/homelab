sudo systemctl reboot

sudo apt update
sudo apt -y upgrade
sudo systemctl reboot

sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt -y autoremove
sudo apt-mark hold kubelet kubeadm kubectl

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system




sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates docker.io
sudo mkdir -p /etc/systemd/system/docker.service.d

sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker

# make sure that the br_netfilter module is loaded
lsmod | grep br_netfilter
sudo systemctl enable kubelet

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### On WORKER
kubeadm join blue:6443 --token 4yih9o.4wodrw13fs38yi6u     --discovery-token-ca-cert-hash sha256:42e50623bdcc0e718aa62e62a14020014dd22163f0409e5baadbeb995706a6a8 
