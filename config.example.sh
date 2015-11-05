#!/usr/bin/env bash

# The name of the docker machine
DOCKER_MACHINE_NAME=default

# The name of the docker-image to work with
DOCKER_IMAGE_NAME=myimage

# The script that has to be run to start the docker-container
DOCKER_STARTSCRIPT=~/docker/start.sh

# The script used to build the docker-image
DOCKER_BUILDSCRIPT=~/docker/build.sh

# Wheather or not to require a specific value to be present in /etc/resolv.conf (Optional)
DOCKER_DNS_REQUIRED=customdns

# Require a certain VPN connection to run with Viscosity (Optional)
VISCOSITY_CONNECTION_NAME=myvpn