#!/bin/bash

# Update the package list and install necessary dependencies
sudo apt-get update -y
sudo apt-get install -y apt-transport-https curl

# Download and add the Kubernetes signing key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add the Kubernetes repository to apt sources list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the package list again
sudo apt-get update -y

# Install Docker, kubelet, kubeadm, and kubectl
sudo apt-get install -y docker.io kubelet kubeadm kubectl

# Enable and start Docker and kubelet services
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl enable kubelet
sudo systemctl start kubelet

# Initialize the Kubernetes cluster (use your desired pod network CIDR)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a pod network addon (Flannel in this case)
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Print a message with instructions for joining nodes to the cluster
echo "Kubernetes master has been installed successfully. You can now join worker nodes to this cluster by running the following command on each node:"
echo "sudo kubeadm join <master-ip>:<master-port> --token <token> --discovery-token-ca-cert-hash <hash>"
