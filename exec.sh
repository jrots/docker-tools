#!/bin/bash

#Init config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/config.sh

#Check if it is running
if [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" != "Running" ]
then
	echo "Docker-machine "$DOCKER_MACHINE_NAME" is not running"
	exit
fi

#Set env values
eval "$( docker-machine env "$DOCKER_MACHINE_NAME" )"

#Fetch the container id of mm-dev
DOCKER_CONTAINERID="$( docker ps | grep "$DOCKER_IMAGE_NAME" | cut -f 1 -d " " )"

#Checking if id is set
if [ -z $DOCKER_CONTAINERID ]
then
	echo "Docker-container $DOCKER_IMAGE_NAME is not running"
	exit
fi

#Run passed command
if [ $# == 1 ]
then
	COMMAND=$@
else
	COMMAND="$( printf '"%s" ' "$@" )"
fi
docker exec -i "$DOCKER_CONTAINERID" bash << EOF

	if [ ${#COMMAND} > 0 ] && [[ ! "${COMMAND}" =~ ^[[:space:]].*$ ]]
	then
		echo '' &> /dev/null #Do this otherwise error when COMMAND is empty
		$COMMAND
	fi

EOF