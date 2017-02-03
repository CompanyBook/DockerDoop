#!/bin/bash
CURRENT_IP=`ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}' | head -1`
cat singlenode-sample.ini.origin | sed "s/localhost/$CURRENT_IP/g" > singlenode-sample.ini

POSTFIX=${1:-2}
IMAGE=${2:-companybookbuild-002.servers.prgn.misp.co.uk:5000/singlenode-hdp}


HOST=$(echo "$IMAGE" | sed 's/\/.*//')
sudo mkdir -p "/etc/docker/certs.d/$HOST"
sudo cp ca.crt "/etc/docker/certs.d/$HOST/"
echo "/etc/docker/certs.d/$HOST/ca.crt"
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ca.crt

docker pull $IMAGE

CONTAINER_POSTFIX=$POSTFIX SERVER_NODE_IMAGE=$IMAGE ./scripts/createCluster.sh singlenode-sample.ini

sleep 60

CONTAINER_POSTFIX=$POSTFIX scripts/startCluster.sh singlenode-sample.ini
