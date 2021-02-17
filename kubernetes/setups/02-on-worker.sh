sudo apt update
sudo apt -y upgrade
sudo systemctl reboot

sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt -y install vim git curl dnsutils net-tools nmap wget kubelet kubeadm kubectl
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
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates 

sudo apt install resolvconf

echo 'nameserver 8.8.8.8' | sudo tee -a /etc/resolvconf/resolv.conf.d/head
echo 'nameserver 8.8.4.4' | sudo tee -a /etc/resolvconf/resolv.conf.d/head

sudo systemctl start resolvconf.service
sudo systemctl enable resolvconf.service
sudo systemctl status resolvconf.service

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
  "storage-driver": "overlay2",
  "default-address-pools": [
    {
      "base": "10.10.0.0/16",
      "size": 28
    }
  ]
}
EOF
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
########## DOCKER   END #########

# make sure that the br_netfilter module is loaded
lsmod | grep br_netfilter
sudo systemctl enable kubelet


# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

### On WORKER
kubeadm join blue.pkvnw:6443 --token fio9cg.8id4vs4sitonbcgg   --discovery-token-ca-cert-hash sha256:c77c9b240ea1f459dca366664c0fe94f5d73d7eee8f678022e37f335a445ad07