#!/usr/bin/env bash

# Note: Every Optional value can be left blank or can be commented out.


# The name of the docker machine.
DOCKER_MACHINE_NAME="default"

# The name of the docker-image to work with.
# This will be the same name as the name of the image you build in your builds-script.
DOCKER_IMAGE_NAME="myimage"

# The script used to build the docker-image ('docker build ...').
# You don't need to worry about environment-variables, whether or not the machine is running,
# or check if you're connection to your VPN, this is al done automatically for you.
DOCKER_BUILDSCRIPT="~/docker/build.sh"

# The script that has to be run to start the docker-container ('docker compose ...' or 'docker run ...').
# Just as with the build-script you don't need to worry about a thing.
DOCKER_STARTSCRIPT="~/docker/start.sh"

# Whether or not a specific value is required in /etc/resolv.conf (which are the dns-settings) (Optional).
# This can be used to make sure the dns-settings of the VPN connection are used inside Docker.
DOCKER_DNS_REQUIRED="customdns"

# Require a certain VPN connection to run with Viscosity (Optional).
# When the value is set to '---' all VPN connections will be disconnected.
VISCOSITY_CONNECTION_NAME="myvpn"

# Require a certain VPN connection to run with Tunnelblick (Optional).
# When the value is set to '---' all VPN connections will be disconnected.
TUNNELBLICK_CONNECTION_NAME="myvpn"