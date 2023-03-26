#! /bin/env bash

source ./env.sh

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
red="$( echo -e '\033[0;31m' )" # Red
grn="$( echo -e '\033[0;32m' )" # Green
rst="$( echo -e '\033[0m' )"    # Reset Color format

echo -e $grn"\nCreating machine..."$rst
# create docker-machine for my K8s
docker-machine create \
	--driver amazonec2 \
	--amazonec2-region eu-west-1 \
	--amazonec2-ami ami-07d8796a2b0f8d29c \
	--amazonec2-instance-type t2.medium \
	--amazonec2-open-port 8080 \
$DOCKER_MACHINE_NAME

# changed JENKINS_URL in accordance with public IP EC2 instance
DOCKER_MACHINE_PUBLIC_IP=`docker-machine ip "$DOCKER_MACHINE_NAME"`
sed -i '/JENKINS_URL/d' ../jenkins/.env
echo "JENKINS_URL=http://$DOCKER_MACHINE_PUBLIC_IP:8080/" >> ../jenkins/.env

echo -e $grn"\nCreating sync folder..."$rst
cd "$ROOT_DIR"
docker-machine ssh "$DOCKER_MACHINE_NAME" mkdir "$SYNC_FOLDER"
docker-machine scp -r ./"$SYNC_FOLDER/" "$DOCKER_MACHINE_NAME":"/home/$MACHINE_USER/"
cd "$CWD"

echo -e $grn"\nCoping sshkey for github..."$rst
docker-machine scp ./ssh_key/id_rsa "$DOCKER_MACHINE_NAME":"/home/$MACHINE_USER/.ssh/id_rsa"
docker-machine ssh "$DOCKER_MACHINE_NAME" "chmod 400 /home/"$MACHINE_USER"/.ssh/id_rsa"

echo -e $grn"\nCoping PAT for github..."$rst
docker-machine ssh "$DOCKER_MACHINE_NAME" mkdir .github
docker-machine scp ./ghcr_cred/github_pat "$DOCKER_MACHINE_NAME":"/home/$MACHINE_USER/.github/github_pat"

echo -e $grn"\nCoping .kube/config..."$rst
docker-machine ssh "$DOCKER_MACHINE_NAME" mkdir .kube
docker-machine scp ./.kube/config "$DOCKER_MACHINE_NAME":"/home/$MACHINE_USER/.kube/config"

echo -e $grn"\nActivating machine.."$rst
echo -e $grn"Docker machine ip - $DOCKER_MACHINE_PUBLIC_IP"$rst
echo -e $red"Run this command to configure your shell:"$rst
echo -e $red"docker-machine use $DOCKER_MACHINE_NAME"$rst
