#!/bin/bash
#
# Create docker container
#

# Random password function
function randomPass(){
  < /dev/urandom tr -dc _#A-Z-a-z-0-9 | head -c${1:-32};echo;
}

# Random user function
function randomUser(){
  < /dev/urandom tr -dc a-z-0-9 | head -c${1:-8};echo;
}

# Docker image
IMG="zekaf/namecoin-core"
TAG="latest"

# Docker Namecoin container
NMC_CT="namecoin"
NMC_IP="10.17.0.2"

# Docker network
NET_NAME="isolated_nw"
NET_SUBNET=$(docker network inspect -f '{{range .IPAM.Config}}{{.Subnet}}{{end}}' $NET_NAME)

# Namecoin configuration
RPC_USER=$(randomUser)
RPC_PASS=$(randomPass)
RPC_PORT="8336"
PORT="8334"
MAX_CONNECTIONS="10"

# Host directory
HOSTDIR="/opt/docker/data"

# Create docker container
docker run -d \
  --net $NET_NAME --ip $NMC_IP \
  --name $NMC_CT \
  --restart=always \
  --volume=$HOSTDIR/$NMC_CT:/data/namecoin \
  -e RPC_USER=$RPC_USER \
  -e RPC_PASS=$RPC_PASS \
  -e RPC_ALLOW_IP=$NET_SUBNET \
  -e RPC_PORT=$RPC_PORT \
  -e PORT=$PORT \
  -e MAX_CONNECTIONS=$MAX_CONNECTIONS \
  $IMG:$TAG
