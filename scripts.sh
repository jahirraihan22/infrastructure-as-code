#! /bin/bash

# Check if the script is being run as root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root."
  exit 1
fi

# Disable swap immediately
sudo swapoff -a

# Backup the original /etc/fstab file
cp /etc/fstab /etc/fstab.backup

# Remove swap entries from /etc/fstab
sed -i '/\sswap\s/s/^/#/' /etc/fstab

echo "Swap has been disabled and removed from /etc/fstab."

envPath=$(echo "$0" | sed "s/\/[^/]*$/\/\.env/")


if [[ -e "$envPath" ]]; then
    source $envPath
else
    echo ".env is required.....exiting"
    exit 1
fi


if [[ -z "$NODE_TYPE" ]];then
    echo "NODE_TYPE is required.....exiting"
    exit 1
fi

if [[ $NODE_TYPE == "master" ]];then
    if [[ -z "$IP_ADDRESS" ]];then
        echo "IP_ADDRESS is required.....exiting"
        exit 1
    fi
fi

echo -e "Initializing Node $(hostname) \n================================================\n "

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF


cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system


echo -e "Configure persistent loading of modules \n================================================\n"
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

echo -e "Load at runtime\n================================================\n"
sudo modprobe overlay
sudo modprobe br_netfilter

echo -e "Ensure sysctl params are set\n================================================\n"
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo -e "Reload configs\n================================================\n"
sudo sysctl --system

echo -e "Install required packages\n================================================\n"
sudo apt-get update
sudo apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

echo -e "Add Docker repo\n================================================\n"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo -e "Install containerd\n================================================\n"
sudo apt update
sleep 1
sudo apt install -y containerd.io

echo -e "Configure containerd and start service\n================================================\n"

mkdir -p /etc/containerd

containerd config default>/etc/containerd/config.toml

sleep 1

echo -e "Restart containerd\n================================================\n"
sudo systemctl restart containerd
sleep 1
sudo systemctl enable containerd
sleep 1

echo -e "Installing K8s components\n================================================\n"

mkdir -p /etc/apt/keyrings

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00

sudo apt-mark hold kubelet kubeadm kubectl

sleep 1

#sudo systemctl status  kubectl

if [[ $NODE_TYPE == "master" ]];then
    echo -e "Initializing master node\n================================================\n"
    kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address $IP_ADDRESS --pod-network-cidr=10.244.0.0/16 | tee /tmp/kubeadm.log
    DISCOVERY_TOKEN_CA_CERT_HASH=$(cat /tmp/kubeadm.log | tail -2 | grep -o -- '--discovery-token-ca-cert-hash [^[:space:]]*' | awk '{print $2}')
    TOKEN=$(cat /tmp/kubeadm.log | tail -2 | grep -o -- '--token [^[:space:]]*' | awk '{print $2}') 
    
    sed -i "s/^DISCOVERY_TOKEN_CA_CERT_HASH=.*/DISCOVERY_TOKEN_CA_CERT_HASH=$DISCOVERY_TOKEN_CA_CERT_HASH/" $envPath
    sed -i "s/^TOKEN=.*/TOKEN=$TOKEN/" $envPath

    sudo rm -rf /tmp/kubeadm.log

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    echo -e "\n---------------------> Copy this $envPath file into worker node for joining with master node <---------------------\n"
fi

if [[ $NODE_TYPE == "worker" ]]; then
    if [[ -z "$TOKEN" ]];then
        echo "TOKEN is required.....exiting"
        exit 1
    fi

    if [[ -z "$DISCOVERY_TOKEN_CA_CERT_HASH" ]];then
        echo "DISCOVERY_TOKEN_CA_CERT_HASH is required.....exiting"
        exit 1
    fi

    kubeadm join $IP_ADDRESS:6443 --token $TOKEN --discovery-token-ca-cert-hash $DISCOVERY_TOKEN_CA_CERT_HASH
fi
