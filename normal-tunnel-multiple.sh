#!/bin/bash

HOST=$1
PORTS="${@:2}"

RED="\033[1;31m"
GREEN="\033[1;32m"
ORANGE="\033[1;33m"
NC="\033[0m"

cmd="ssh "
for p in ${PORTS}; do
    printf "${GREEN}>>> [SSH] $(hostname):${p} "'\u2192'" ${HOST}:${p}${NC}"'\n'
    cmd=${cmd}" -L ${p}:localhost:${p} "
done
cmd=${cmd}" ${HOST} -N"

printf "${ORANGE}command: ${cmd}${NC}"'\n'

exec ${cmd}
