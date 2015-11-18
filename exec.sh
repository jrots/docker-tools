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

#Fetch the container id of mm-dev
DOCKER_CONTAINERID="$( docker ps | grep "$DOCKER_IMAGE_NAME" | cut -f 1 -d " " )"

#Checking if id is set
if [ -z "$DOCKER_CONTAINERID" ]
then
	echo "Docker-container $DOCKER_IMAGE_NAME is not running"
	exit
fi

#Process input
TYPE=command
if [ $# == 1 ]
then
	INPUT=$@

	#Check if file
	if [ -f "$INPUT" ]
	then
		TYPE=file
	fi
elif [ $# != 0 ]
then
	INPUT="$( printf '"%s" ' "$@" )"
fi

if [ "$TYPE" == "file" ]
then
	#Execute as file
	docker exec -i "$DOCKER_CONTAINERID" bash < "$INPUT"
else
	if [ ! -z "$INPUT" ]
	then
		#Execute as command
		docker exec -i "$DOCKER_CONTAINERID" bash << EOF
			$INPUT
EOF
	else
		#Open exec session
		docker exec -it "$DOCKER_CONTAINERID" bash
	fi
fi