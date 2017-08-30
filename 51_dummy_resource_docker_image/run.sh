#!/bin/bash

stub=$1; shift
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
export ATC_URL=${ATC_URL:-"http://192.168.100.4:8080"}
export fly_target=${fly_target:-lite}
echo "Concourse API target ${fly_target}"
echo "Concourse API $ATC_URL"
echo "Tutorial $(basename $DIR)"

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

usage() {
  echo "USAGE: run.sh path/to/credentials.yml"
  exit 1
}


if [ -z "${stub}" ]; then
  stub="../credentials.yml"
fi
stub=$(realpath $stub)
if [ ! -f ${stub} ]; then
  usage
fi


pushd $DIR
  fly sp -t ${fly_target} configure -c pipeline.yml -p main --load-vars-from ${stub} -n
  fly -t ${fly_target} unpause-pipeline --pipeline main
  fly -t ${fly_target} trigger-job -j main/job-publish
  fly -t ${fly_target} watch -j main/job-publish
popd
