#!/bin/bash
MM_DOCKER=/Users/lowiehuyghe/MM/projects/docker-mm/
VISCOSITY=MM

#Fix VPN state
VPN_STATE="$( osascript -e 'tell application "Viscosity" to get the state of first connection' )"
if [ "$VPN_STATE" != "Connected" ]
then
	echo "Connecting to vpn"
	osascript -e "tell application \"Viscosity\" to connect \"$VISCOSITY\""
fi
while [ "$VPN_STATE" != "Connected" ]
do
	sleep .5
	VPN_STATE="$( osascript -e 'tell application "Viscosity" to get the state of first connection' )"
done

STOP_DOCKER="0"

#Check if is already running
if [ "$STOP_DOCKER" == "0" ] && [ "$( docker-machine status default )" == "Running" ]
then
	eval "$( docker-machine env default )"

	#Check if vpn settings are on
	docker-machine ssh default << EOF > /tmp/stop_docker.tmp

		if ! cat /etc/resolv.conf | grep netnoc &> /dev/null
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
	echo "Stopping docker-machine default"

	docker-machine stop default
fi
if [ "$( docker-machine status default )" != "Running" ]
then
	echo "Starting docker-machine default"

	docker-machine start default
	eval "$( docker-machine env default )"
fi

#Start container
cd "$MM_DOCKER"
./startcontainer/start.sh