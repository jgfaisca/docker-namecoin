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
IMG="zekaf/namecoind"

# Image tag
TAG="latest"

# Host directory
HOSTDIR="/opt/docker/data"

# Container name
NAME="namecoin"

RPC_USER=$(randomUser)
RPC_PASS=$(randomPass)

# Create docker container
docker run -d \
  --name $NAME \
  --restart=always \
  --volume=$HOSTDIR/$NAME:/data/namecoin \
  -e RPC_USER=$RPC_USER \
  -e RPC_PASS=$RPC_PASS \
  -e RPC_ALLOW_IP="172.17.0.0/16" \
  -e MAX_CONNECTIONS=10 \
  -e RPC_PORT=8336 \
  -e PORT=8334 \
  $IMG:$TAG
  
