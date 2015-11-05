# docker-mm-tools
Tools for the MM-docker

## Installation

### Configuration
1. Make a copy of ```config.example.sh``` and rename it to ```config.sh```.
2. Make sure ```config.sh``` is executable by running ```chmod +x config.sh```.
3. Change the configuration to your needs.

## Usage

### start.sh
Used to start the docker-container. It will automatically check your Viscosity-connection (when configured) and make sure the dns-settings are correct inside docker (when configured)
```bash
./start.sh
```

### exec.sh
Used to run a command inside the docker-container.
Example usage:
```bash
./exec.sh echo something
```

### stop.sh
Used to stop the docker-container. It also removes the cached docker-container (not the docker-image) to make sure that after a rebuild it uses the newly created docker-image.
```bash
./stop.sh
```

### restart.sh
Used to start and stop the docker-container.
```bash
./restart.sh
```

### build.sh
Used to (re)build the docker-image.
```bash
./build.sh
```