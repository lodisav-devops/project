#! /bin/env bash

source ./env.sh

# create docker-machine for my K8s
docker-machine create \
	--driver amazonec2 \
	--amazonec2-region eu-west-1 \
	--amazonec2-ami ami-07d8796a2b0f8d29c \
	--amazonec2-instance-type t2.medium \
    --amazonec2-open-port 30100 \
	--amazonec2-open-port 30200 \
	--amazonec2-open-port 80 \
	--amazonec2-open-port 8080 \
	--amazonec2-open-port 6443 \
$DOCKER_MACHINE_NAME

docker-machine env $DOCKER_MACHINE_NAME

# change the name of the docker machine in the script for the created cluster
sed -i "s/\"DOCKER_MACHINE_NAME\"/$DOCKER_MACHINE_NAME/g" ../kind/kind_create.sh

# search for addresses about the docker machine (EC2) and their substitution in the env.sh (for script the created cluster)
aws ec2 describe-instances > 1.txt
private_ip_host=`cat 1.txt | sed -n '/"PrivateIpAddress":/s///p' | sed 's/"ProductCodes":*//' | sed -e 's/,/ /' | tr '[:space:]' '[\n*]' | sed '/^$/d' | sed -n 1p`
public_ip_host=`cat 1.txt | sed -n '/"PublicIpAddress":/s///p' | sed 's/"State":*//' | sed -e 's/,/ /' | tr '[:space:]' '[\n*]' | sed '/^$/d' | sed -n 1p`
rm 1.txt

sed -i "s/\"PRIVATE_IP\"/$private_ip_host/g" ../kind/env.sh
sed -i "s/\"PUBLIC_IP\"/$public_ip_host/g" ../kind/env.sh
