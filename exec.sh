#!/bin/bash
CONTAINER_NAME="mm-dev"

#Set env values
eval "$( docker-machine env default )"

#Fetch the container id of mm-dev
DOCKER_CONTAINERID="$( docker ps | grep "$CONTAINER_NAME" | cut -f 1 -d " " )"

#Checking if id is set
if [ -z $DOCKER_CONTAINERID ]
then
	echo "Docker-container $CONTAINER_NAME is not running"
	exit
fi

#Run passed command
COMMAND="$( printf '"%s" ' "$@" )"
docker exec -i "$DOCKER_CONTAINERID" bash << EOF

	cd /opt/code

	if [ ${#COMMAND} > 0 ] && [[ ! "${COMMAND}" =~ ^[[:space:]].*$ ]]
	then
		echo '' &> /dev/null #Do this otherwise error when COMMAND is empty
		$COMMAND
	fi

EOF