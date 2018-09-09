#!/usr/bin/env bash

set -e
set -o noglob

#
# font and color 
#
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
white=$(tput setaf 7)

#
# header and logging
#
header() { printf "\n${underline}${bold}${blue}> %s${reset}\n" "$@"; }
header2() { printf "\n${underline}${bold}${blue}>> %s${reset}\n" "$@"; }
info() { printf "${white}➜ %s${reset}\n" "$@"; }
success() { printf "${green}✔ %s${reset}\n" "$@"; }
error() { printf "${red}✖ %s${reset}\n" "$@"; }
warn() { printf "${yellow}➜ %s${reset}\n" "$@"; }
usage() { printf "\n${underline}${bold}${blue}Usage:${reset} ${blue}%s${reset}\n" "$@"; }

trap "error '******* ERROR: Something went wrong.*******'; exit 1" sigterm
trap "error '******* Caught sigint signal. Stopping...*******'; exit 2" sigint

set +o noglob

#
# entry base dir
#
pwd=`pwd`
base_dir="${pwd}"
source="$0"
while [ -h "$source" ]; do
    base_dir="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$base_dir/$source"
done
base_dir="$( cd -P "$( dirname "$source" )" && pwd )"
cd ${base_dir}

DOCKER_REPOSTORY=myharbor.com
DOCKER_PROJECT=base
DOCKER_IMAGE=java

# run default command
docker run -it --rm --name alpine-java-1.8.181 ${DOCKER_REPOSTORY}/${DOCKER_PROJECT}/${DOCKER_IMAGE}:alpine-java-1.8.181
# run sshd
docker run -it --rm --name alpine-java-1.8.181 -p 10022:22 ${DOCKER_REPOSTORY}/${DOCKER_PROJECT}/${DOCKER_IMAGE}:alpine-java-1.8.181 ""
# run bash
docker run -it --rm --name alpine-java-1.8.181 -p 18080:8080 -p 10001:10001 -p 10002:10002 ${DOCKER_REPOSTORY}/${DOCKER_PROJECT}/${DOCKER_IMAGE}:alpine-java-1.8.181 "bash"
