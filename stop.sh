#!/bin/bash
CONTAINER_NAME="mm-dev"

#Stopping docker-machine
if [ "$( docker-machine status default )" == "Running" ]
then
	eval "$( docker-machine env default )"

	CONTAINER_ID="$( docker ps | grep "$CONTAINER_NAME" | cut -f 1 -d " " )"
	if [ ! -z $CONTAINER_ID ]
	then
		echo "Stopping docker-container"
		docker stop "$CONTAINER_ID"
	fi
fi