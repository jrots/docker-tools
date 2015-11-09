#!/bin/bash

#Init config
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
chmod +x $DIR/config.sh
. $DIR/config.sh

#Fix VPN state
#Viscosity
if [ ! -z "$VISCOSITY_CONNECTION_NAME" ]
then
	if [ "$VISCOSITY_CONNECTION_NAME" != "---" ]
	then
		VPN_STATE="$( osascript -e "tell application \"Viscosity\" to get the state of first connection where name is equal to \"$VISCOSITY_CONNECTION_NAME\"" )"

		if [ "$VPN_STATE" != "Connected" ]
		then
			echo "Connecting to VPN \"$VISCOSITY_CONNECTION_NAME\""
			osascript -e "tell application \"Viscosity\" to connect \"$VISCOSITY_CONNECTION_NAME\"" &> /dev/null
		fi
		while [ "$VPN_STATE" != "Connected" ]
		do
			sleep .5
			VPN_STATE="$( osascript -e "tell application \"Viscosity\" to get the state of first connection where name is equal to \"$VISCOSITY_CONNECTION_NAME\"" )"
		done
	else
		VPN_STATE="$( osascript << EOF
			tell application "Viscosity"
				try
					get the name of first connection where state is not equal to "Disconnected"
				on error errorMessage number errorNumber
					if errorNumber is not equal to -1719 then
						log ("Execution error: " & errorMessage & " (" & errorNumber & ")")
					end if
				end try
			end tell
EOF
)"
		if [ ! -z "$VPN_STATE" ]
		then
			echo "Disconnecting from all VPN connections"
			osascript -e "tell application \"Viscosity\" to disconnectall" &> /dev/null
		fi
		while [ ! -z "$VPN_STATE" ]
		do
			sleep .5
			VPN_STATE="$( osascript << EOF
				tell application "Viscosity"
					try
						get the name of first connection where state is not equal to "Disconnected"
					on error errorMessage number errorNumber
						if errorNumber is not equal to -1719 then
							log ("Execution error: " & errorMessage & " (" & errorNumber & ")")
						end if
					end try
				end tell
EOF
)"
		done
	fi
fi
#Tunnelblick
if [ ! -z "$TUNNELBLICK_CONNECTION_NAME" ]
then
	if [ "$TUNNELBLICK_CONNECTION_NAME" != "---" ]
	then
		VPN_STATE=$( osascript -e "tell application \"Tunnelblick\" to get state of first configuration where name is equal to \"$TUNNELBLICK_CONNECTION_NAME\"" )

		if [ "$VPN_STATE" != "CONNECTED" ]
		then
			echo "Connecting to VPN \"$TUNNELBLICK_CONNECTION_NAME\""
			osascript -e "tell application \"Tunnelblick\" to connect \"$TUNNELBLICK_CONNECTION_NAME\"" &> /dev/null
		fi
		while [ "$VPN_STATE" != "CONNECTED" ]
		do
			sleep .5
			VPN_STATE="$( osascript -e "tell application \"Tunnelblick\" to get state of first configuration where name is equal to \"$TUNNELBLICK_CONNECTION_NAME\"" )"
		done
	else
		VPN_STATE="$( osascript << EOF
			tell application "Tunnelblick"
				try
					get the name of first configuration where state is not equal to "EXITING"
				on error errorMessage number errorNumber
					if errorNumber is not equal to -1719 then
						log ("Execution error: " & errorMessage & " (" & errorNumber & ")")
					end if
				end try
			end tell
EOF
)"
		if [ ! -z "$VPN_STATE" ]
		then
			echo "Disconnecting from all VPN connections"
			osascript -e "tell application \"Tunnelblick\" to disconnect all" &> /dev/null
		fi
		while [ ! -z "$VPN_STATE" ]
		do
			sleep .5
			VPN_STATE="$( osascript << EOF
				tell application "Tunnelblick"
					try
						get the name of first configuration where state is not equal to "EXITING"
					on error errorMessage number errorNumber
						if errorNumber is not equal to -1719 then
							log ("Execution error: " & errorMessage & " (" & errorNumber & ")")
						end if
					end try
				end tell
EOF
)"
		done
	fi
fi

STOP_DOCKER="0"

#Check if is already running
if [ ! -z "$DOCKER_DNS_REQUIRED" ] && [ "$STOP_DOCKER" == "0" ] && [ "$( docker-machine status "$DOCKER_MACHINE_NAME" )" == "Running" ]
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