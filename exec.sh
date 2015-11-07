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
else
	INPUT="$( printf '"%s" ' "$@" )"
fi

if [ "$TYPE" == "file" ]
then
	#Execute as file
	docker exec -i "$DOCKER_CONTAINERID" bash < "$INPUT"
else
	#Execute as command
	docker exec -i "$DOCKER_CONTAINERID" bash << EOF

		if [ ${#COMMAND} > 0 ] && [[ ! "${INPUT}" =~ ^[[:space:]].*$ ]]
		then
			echo '' &> /dev/null #Do this otherwise error when INPUT is empty
			$INPUT
		fi
EOF
fi