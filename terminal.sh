#!/bin/bash

#Init config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
chmod +x $DIR/config.sh
. $DIR/config.sh

#Check if it is running
if [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" != "Running" ]
then
	echo "Docker-machine "$DOCKER_MACHINE_NAME" is not running"
	exit
fi

#Set env values
eval "$( docker-machine env "$DOCKER_MACHINE_NAME" )"