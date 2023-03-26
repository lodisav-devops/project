#!/usr/bin/env bash

export TOPIC="v1"
export DEPLOY_TYPE="$TOPIC demo app"
export DEPLOYDATE=$(date +%Y%m%d-%H%M)
export NAMESPACE="default"
export RELEASE_VER="${TOPIC,,}"
export GITHUB_REGISTRY_OWNER="lodisav-devops"
export REGISTRY="ghcr.io/${GITHUB_REGISTRY_OWNER}"
export GITHUB_REGISTRY_SECRET="github-cred"
export GITHUB_REGISTRY_SECRET_FILE="./secrets/.dockerconfigjson"
