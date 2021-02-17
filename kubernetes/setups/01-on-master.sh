 apt update
 apt -y upgrade

############ SETUP CONTROL-PLAN HOSTNAME START ############
cat <<EOF |  tee /etc/hosts
wall.pkvnw 
EOF
############ SETUP CONTROL-PLAN HOSTNAME END ############
########## SETUP NAMESERVER START #########
#  apt install resolvconf

# echo 'nameserver wall.pkvnw' |  tee -a /etc/resolvconf/resolv.conf.d/head
# echo 'nameserver 8.8.8.8' |  tee -a /etc/resolvconf/resolv.conf.d/head
# echo 'nameserver 8.8.4.4' |  tee -a /etc/resolvconf/resolv.conf.d/head

#  systemctl start resolvconf.service
#  systemctl enable resolvconf.service
#  systemctl status resolvconf.service
 ########## SETUP NAMESERVER END #########

 systemctl reboot

########## Setup Node START #########
 apt -y install curl git wget gnupg2 software-properties-common apt-transport-https ca-certificates 

 sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
 swapoff -a

 modprobe overlay
 modprobe br_netfilter

 tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

#  sysctl --system
# make sure that the br_netfilter module is loaded
  lsmod | grep br_netfilter
########## Setup Node END #########

########## DOCKER START #########
 apt-get update
 apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 apt-get update
 apt-get install -y containerd.io=1.2.13-2 docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
 apt-mark hold docker-ce docker-ce-cli containerd.io
 mkdir /etc/docker
cat <<EOF |  tee /etc/docker/daemon.json
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
 mkdir -p /etc/systemd/system/docker.service.d
 systemctl daemon-reload 
 systemctl restart docker
 systemctl enable docker
########## DOCKER   END #########


########## Install K8s START #########

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee /etc/apt/sources.list.d/kubernetes.list
 apt update

 apt -y install kubelet kubeadm kubectl 
 apt-mark hold kubelet kubeadm kubectl
   systemctl enable kubelet
########## Install K8s END #########

########## Setup K8s Start #########
 kubeadm config images pull

 kubeadm init --control-plane-endpoint=blue.pkvnw --ignore-preflight-errors=DirAvailable--var-lib-etcd

sudo mkdir -p /home/pkv/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/pkv/.kube/config
sudo  chown $(id -u):$(id -g) /home/pkv/.kube/config

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl taint nodes node-role.kubernetes.io/master:NoSchedule-

########## Setup K8s END #########


########## Verify #########
kubectl get nodes
#kubeadm token create --print-join-command
#kubectl taint nodes blue node-role.kubernetes.io/master:NoSchedule-
#kubectl taint nodes charlie node-role.kubernetes.io/master:NoSchedule-
#kubectl taint nodes delta node-role.kubernetes.io/worker:NoSchedule-
#kubectl taint nodes delta node.kubernetes.io/unreachable:NoExecute-
kubectl describe nodes blue charlie delta | grep Taint
# kubeadm join 192.168.0.27:6443 --token tl4mle.2cplb2lqvkdyfinj --discovery-token-ca-cert-hash sha256:b54d91ee19c68601cc97cdb9b58a21c0bcc67e015af0cae4c207c612004ee6c2 
########## Verify END #########


########## Troubleshoot Start #########
 cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
#Set Environment="KUBELET_EXTRA_ARGS=--resolv-conf=/run/systemd/resolve/resolv.conf"
########## Troubleshoot End #########