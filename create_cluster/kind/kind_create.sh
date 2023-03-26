#! /bin/env bash

source ./env.sh

eval $(docker-machine env "DOCKER_MACHINE_NAME")

# create kind cluster
envsubst < config.yaml | kind create cluster --config=-

# add external ip docker-machine into kubeconfig
echo "Edit kube config file..."
sed -i "s/$DOCKER_HOST_IP/$DOCKER_HOST_EXTERNAL_IP/g" ~/.kube/config

# install Calico
echo "Install Calico CNI..."
kubectl --insecure-skip-tls-verify apply -f calico.yaml

# scale down CoreDNS
echo "Scale down coreNDS..."
kubectl --insecure-skip-tls-verify scale deployment --replicas 1 coredns --namespace kube-system

# install Nginx ingress controller
echo "Install Ingress NGINX..."
kubectl --insecure-skip-tls-verify apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# install Metrics-server
echo "Install Metrics-server..."
kubectl --insecure-skip-tls-verify apply -f metrics-server.yaml

# get kubernetes cluster info
kubectl --insecure-skip-tls-verify cluster-info
