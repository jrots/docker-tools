#!/bin/bash

#Init config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
chmod +x $DIR/config.sh
. $DIR/config.sh

#Stopping docker-machine
if [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" == "Running" ]
then
	eval "$( docker-machine env "$DOCKER_MACHINE_NAME" )"

	CONTAINER_ID="$( docker ps | grep "$DOCKER_IMAGE_NAME" | cut -f 1 -d " " )"
	if [ ! -z "$CONTAINER_ID" ]
	then
		echo "Stopping docker-container"
		docker stop "$CONTAINER_ID"
		docker rm "$CONTAINER_ID"
	fi
fi