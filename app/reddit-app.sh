#!/usr/bin/env bash

T1=$(date +%s)
K8SDP="./k8s-manifests"
CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

source ./env.sh
source ./shell/func.sh
source ./shell/menu.sh


action() {
  # Start new log
  LOGFILE="${CWD}/${DEPLOYDATE}-${1}.log"
  echo "--- Start LOG" > "${LOGFILE}"

  # Deployment data head output
  echo "--- ${DEPLOYDATE} :: Begin ${1}. (NS: ${NAMESPACE}, TAG: ${RELEASE_VER}) ---" >>"${LOGFILE}"
  echo "---[ ${bpur}Begin ${1}${rst} ]---"
  echo "Namespace:  ${bgrn}${NAMESPACE^^}${rst}"
  echo "Version:    ${bgrn}${RELEASE_VER}${rst}"

  # create secret for pull images from github
  kube_secret $1 $NAMESPACE ${GITHUB_REGISTRY_SECRET_FILE}

  while IFS= read -r -d '' file; do
    kube_action $1 $NAMESPACE $file
  done < <(find $K8SDP -type f -print0)

  # Final running time
  echo $line
  T2=$(date +%s)
  let "TSUM1 = T2 - T1"
  echo "The script has been running for ${bpur}${TSUM1}${rst} second."
  echo "${bgrn}${1} complete!${rst}"
}

clear
echo $deploy
menu_process
