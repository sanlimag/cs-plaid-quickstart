#!/bin/bash

####################################################
# Usage
####################################################
usage() {
  echo ""
  echo "Usage: $0 -i <ec2-ip-address> -c <path-to-certificate>  -v <app-version>"
  echo ""

  exit 1
}

####################################################
# Main
####################################################

SERVER_IP=
CERT_PATH=
APP_VERSION=

while getopts i:c:v: opt
do
  case "$opt" in
    i) SERVER_IP=$OPTARG;;
    c) CERT_PATH=$OPTARG;;
    v) APP_VERSION=$OPTARG;;
  esac
done

if [[ -z "$SERVER_IP" ]] || [[ -z "$CERT_PATH" ]] || [[ -z "$APP_VERSION" ]]; then
  usage
fi

if [ $APP_VERSION = 1 ]
then
  clear
  echo "Deploying v1"
  ssh -tt -i $CERT_PATH ubuntu@$SERVER_IP << EOF
    cd fintech-demo
    git fetch
    git reset --hard origin/master
    git checkout master
    sudo docker-compose down && sudo docker-compose up --build -d
    exit
EOF
  echo "---------------------------------------------------------------------------"
  echo "Application $APP_VERSION deployed. You can access it on http://$SERVER_IP"
elif [ $APP_VERSION = 2 ]
then
  clear
  echo "Deploying v2"
  ssh -tt -i $CERT_PATH ubuntu@$SERVER_IP <<EOF
    cd fintech-demo
    git checkout ext_logging
    sudo docker-compose down && sudo docker-compose up --build -d
    exit
EOF
  echo "---------------------------------------------------------------------------"
  echo "Application $APP_VERSION deployed. You can access it on http://$SERVER_IP"
else
  echo "Application version must be 1 or 2"
fi