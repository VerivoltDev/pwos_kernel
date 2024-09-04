#!/usr/bin/bash

{
    [[ -f /etc/timezone ]] && \
        echo "TZ=$(cat /etc/timezone)" || \
        echo "TZ=Etc/UTC"
    echo "DUID=$(id -u)"
    echo "DGID=$(id -g)"
    echo "DUSR=$(whoami)"
    echo "PWD=$(pwd)"
    echo "TERM=$TERM"
    echo "WORKDIR=$(pwd)"
} > .env
