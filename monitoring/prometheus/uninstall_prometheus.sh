#! /bin/env bash

red="$( echo -e '\033[0;31m' )" # Red
grn="$( echo -e '\033[0;32m' )" # Green
rst="$( echo -e '\033[0m' )"    # Reset Color format

err="${red}ERROR:${rst}"
help="Usage: ./uninstall_prometheus.sh [-r release_name] [-n namespace]"

# set defaults args
RELEASE="prometheus"
NAMESPACE="monitoring"

# get args
while [ -n "$1" ]; do
  case "$1" in
    -r)
      if [ -z "$2" ]; then
        echo -e $err" release name not specified\n"$help; exit 1
      else 
        RELEASE="$2"
      fi
      shift ;;
    -n)
      if [ -z "$2" ]; then
        echo -e $err" release name not specified\n"$help; exit 1
      else 
        NAMESPACE="$2"
      fi
      shift ;;
    -h)
      echo $help
      shift ;;
    *)
      echo -e $err" $1 is not an option\n"$help; exit 1
  esac
  shift
done

echo -e $grn"Uninstalling Helm Chart kube-prometheus-stack to namespace ${NAMESPACE}..."$rst
helm --kube-insecure-skip-tls-verify uninstall -n ${NAMESPACE} ${RELEASE}
cd blackbox/
echo -e $grn"Delete blackbox service to namespace ${NAMESPACE}..."$rst
kubectl --insecure-skip-tls-verify -n ${NAMESPACE} delete -f service.yaml
echo -e $grn"Delete blackbox deployment to namespace ${NAMESPACE}..."$rst
kubectl --insecure-skip-tls-verify -n ${NAMESPACE} delete -f deployment.yaml
echo -e $grn"Delete namespace ${NAMESPACE}..."$rst
kubectl --insecure-skip-tls-verify get ns ${NAMESPACE} &>>/dev/null && kubectl --insecure-skip-tls-verify delete ns ${NAMESPACE}
