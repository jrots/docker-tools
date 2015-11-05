#!/bin/bash

#Init config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/config.sh

#Fix VPN state
if [ ! -z $VISCOSITY_CONNECTION_NAME ]
then
	VPN_STATE="$( osascript -e 'tell application "Viscosity" to get the state of first connection' )"
	if [ "$VPN_STATE" != "Connected" ]
	then
		echo "Connecting to vpn"
		osascript -e "tell application \"Viscosity\" to connect \"$VISCOSITY_CONNECTION_NAME\""
	fi
	while [ "$VPN_STATE" != "Connected" ]
	do
		sleep .5
		VPN_STATE="$( osascript -e 'tell application "Viscosity" to get the state of first connection' )"
	done
fi

STOP_DOCKER="0"

#Check if is already running
if [ ! -z $DOCKER_DNS_REQUIRED ] && [ "$STOP_DOCKER" == "0" ] && [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" == "Running" ]
then
	eval "$( docker-machine env "$DOCKER_MACHINE_NAME" )"

	#Check if vpn settings are on
	docker-machine ssh "$DOCKER_MACHINE_NAME" << EOF > /tmp/stop_docker.tmp

		if ! cat /etc/resolv.conf | grep "$DOCKER_DNS_REQUIRED" &> /dev/null
		then
			echo "1"
		else
			echo "0"
		fi
EOF
	STOP_DOCKER="$( tail -1 /tmp/stop_docker.tmp )"
	rm -f /tmp/stop_docker.tmp
fi

#Stop and/or start docker when needed
if [ "$STOP_DOCKER" == "1" ]
then
	echo "Stopping docker-machine "$DOCKER_MACHINE_NAME""

	docker-machine stop "$DOCKER_MACHINE_NAME"
fi
if [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" != "Running" ]
then
	echo "Starting docker-machine "$DOCKER_MACHINE_NAME""

	docker-machine start "$DOCKER_MACHINE_NAME"
fi
eval "$( docker-machine env "$DOCKER_MACHINE_NAME" )"

#Build container
$DOCKER_BUILDSCRIPT