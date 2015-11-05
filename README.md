# docker-mm-tools
Tools for the MM-docker

## Installation

### Configuration
Change the constants in the top of each file to your personal settings in each file. Pretty straight forward.

## Usage

### start.sh
Used to start the docker-container. It will automatically check your Viscosity-connection and make sure the settings are used inside docker.
```
./start.sh
```

### exec.sh
Used to run a command inside the docker-container.
Example usage:
```
./exec.sh echo something
```

### stop.sh
Used to stop the docker-container.
```
./stop.sh
```
