#!/bin/bash

if [ "$1" == "-h" ]; then
    printf "Usage: ./theta-tunnel-ssh.sh <user name> <node id> <port>\n\n"
    printf "\t The script will open a SSH tunnel forwarding the local\n"
    printf "\t port <port> to the port <port> of the Theta compute node\n"
    printf "\t nid<node id>, allowing your client applications to talk\n"
    printf "\t to a remote server running on Theta supercomputer.\n"
    printf "\t Please enter the master rank id without any leading zeros.\n"
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
		printf "${GREEN}>>> [SSH] thetamom1:${PORT} "'\u2192'" nid${NODE}:${PORT}${NC}"'\n'
		ssh -N -L ${PORT}:localhost:$PORT nid${NODE}
	2
1
