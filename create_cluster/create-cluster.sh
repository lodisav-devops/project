#! /bin/env bash

red="$( echo -e '\033[0;31m' )" # Red color
grn="$( echo -e '\033[0;32m' )" # Green color
ylw="$( echo -e '\033[0;33m' )" # Yellow color
wht="$( echo -e '\033[0;37m' )" # White color
rst="$( echo -e '\033[0m' )"    # Reset Color format

line="${wht}---------------------------------------------------------------${rst}"

# create a Docker machine (EC2 in AWS)
echo "Create a EC2 (docker machine) in AWS..."
cd docker-machine/
./docker_machine_create.sh

# create a K8S cluster on the previously created EC2
sleep 2
echo "Create a K8s cluster on the docker machine..."
cd ../kind/
./kind_create.sh
cd ../

source ./docker-machine/env.sh
source ./kind/env.sh

# check variables
echo $line
echo "${red}Private ip on host = $DOCKER_HOST_IP ${rst}"
echo $line
echo "${ylw}Public ip on host = $DOCKER_HOST_EXTERNAL_IP ${rst}"
echo $line
echo "${grn}Docker machine and K8s cluster machine name is $DOCKER_MACHINE_NAME ${rst}"
echo $line

# change variables to default settings
sed -i "s/$DOCKER_MACHINE_NAME/\"DOCKER_MACHINE_NAME\"/g" ./kind/kind_create.sh
sed -i "s/$DOCKER_HOST_IP/PRIVATE_IP/g" ./kind/env.sh
sed -i "s/$DOCKER_HOST_EXTERNAL_IP/PUBLIC_IP/g" ./kind/env.sh

# copy kube-config for jenkins machine
cp ~/.kube/config ../ci_cd/docker-machine/.kube/
sed -i "s/$DOCKER_HOST_EXTERNAL_IP/$DOCKER_HOST_IP/g" ../ci_cd/docker-machine/.kube/config
