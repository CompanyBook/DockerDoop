#!/bin/bash
POSTFIX=${1:-2}
IMAGE=${2:-companybookbuild-002.servers.prgn.misp.co.uk:5000/singlenode-hdp}

CONTAINER_POSTFIX=$POSTFIX SERVER_NODE_IMAGE=singlenode-hdp ./scripts/createCluster.sh singlenode-sample.ini

sleep 60

CONTAINER_POSTFIX=$POSTFIX scripts/startCluster.sh singlenode-sample.ini
