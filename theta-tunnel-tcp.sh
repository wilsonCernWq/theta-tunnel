#!/bin/bash

if [ "$1" == "-h" ]; then
	printf "Usage: ./theta-tunnel.sh <user name> <worker id> <port>\n\n"
	printf "\tThe script will tunnel the local port <port> through\n"
	printf "\tto a connection on Theta compute node nid<worker id>:<port>\n"
	printf "\tallowing you to connect to a remote running vis client.\n"
	printf "\tYou should enter the worker id without any leading zeros.\n"
	exit 0
fi

USER=$1
NODE=`printf "%05d" $2`
PORT=$3

RED="\033[1;31m"
GREEN="\033[1;32m"
ORANGE="\033[1;33m"
NC="\033[0m"

ssh -L $PORT:localhost:$PORT ${USER}@theta.alcf.anl.gov <<-1
	printf "${ORANGE}>>> [SSH] thetalogin:${PORT} "'\u2192'" thetamom1:${PORT}${NC}"'\n'
	ssh -L ${PORT}:localhost:${PORT} thetamom1 <<-2
		printf "${GREEN}>>> [TCP socat] thetamom1:${PORT} "'\u2192'" nid${NODE}:${PORT}${NC}"'\n'
		socat TCP-LISTEN:$PORT,reuseaddr TCP:nid${NODE}:${PORT}
	2
1
