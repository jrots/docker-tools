#!/bin/bash

#Init config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
chmod +x $DIR/config.sh
. $DIR/config.sh

#Stopping docker-machine
if [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" == "Running" ]
then
	#Check if forced is required
	if [ $# == 1 ] && [ "$@" == "-f" ]
	then
		echo "Forcefully stopping virtual-machine"
		VBoxManage controlvm "$DOCKER_MACHINE_NAME" poweroff
	else
		echo "Stopping docker-machine"
		docker-machine stop "$DOCKER_MACHINE_NAME"
	fi
fi