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
DOCKER_FILE=alpine-dockerfile

docker build --rm \
             --no-cache \
             --add-host github.com:192.30.253.112 \
             --add-host github.com:192.30.253.113 \
             --add-host codeload.github.com:192.30.253.120 \
             --add-host codeload.github.com:192.30.253.121 \
             --add-host assets-cdn.github.com:151.101.72.133 \
             --add-host assets-cdn.github.com:151.101.76.133 \
             --add-host github.global.ssl.fastly.net:151.101.73.194 \
             --add-host github.global.ssl.fastly.net:151.101.77.194 \
             --add-host raw.githubusercontent.com:151.101.72.133 \
             --add-host raw.githubusercontent.com:151.101.228.133 \
             --add-host s3.amazonaws.com:52.216.100.205 \
             --add-host s3.amazonaws.com:52.216.130.69 \
             --add-host github-cloud.s3.amazonaws.com:52.216.64.104 \
             --add-host github-cloud.s3.amazonaws.com:52.216.166.91 \
             --add-host github-production-release-asset-2e65be.s3.amazonaws.com:52.216.100.19 \
             --add-host github-production-release-asset-2e65be.s3.amazonaws.com:52.216.230.163 \
             --build-arg MYJRE_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/server-jre-8u181-linux-x64.tar.gz \
             -t ${DOCKER_REPOSTORY}/${DOCKER_PROJECT}/${DOCKER_IMAGE}:alpine-java-1.8.181 \
             -f ${DOCKER_FILE} .
