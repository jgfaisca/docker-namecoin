#!/bin/bash

set -eo pipefail

echo "server=1
daemon=0
maxconnections=${MAX_CONNECTIONS}
rpcuser=${RPC_USER}
rpcpassword=${RPC_PASS}
rpcallowip=127.0.0.1
rpcallowip=${RPC_ALLOW_IP}
rpcport=${RPC_PORT}
port=${PORT}
listen=1
txindex=1" > /data/namecoin/namecoin.conf

exec "$@"
