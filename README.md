# Docker tools
Tools to easily get going with your docker-container. Start, stop, restart, build or execute (!) a command on your docker-container as easy as 1 2 3.

## Installation

### Requirements
* Docker - Your development container (https://www.docker.com/)
* Viscocity - Manages your VPN connections (optional) (https://www.sparklabs.com/viscosity/)

> Note: AppleScript is used to control Viscosity. If this does not work for you, just disable VPN in the `config.sh`. (Or if you're running Windows, take a look [here](https://www.sparklabs.com/support/viswin_command_line))

### Initialization
Start with cloning this repository to your local machine.
```shell
git clone https://github.com/LowieHuyghe/docker-tools.git
```
### Configuration
1. Make a copy of `config.example.sh` and rename it to `config.sh`.
2. Make sure `config.sh` is executable by running
`chmod +x config.sh`
3. Change the configuration to your needs.

### Pro-tip
These script were mainly meant to be used with aliases so you can setup your docker-container as easy as 123.
```shell
alias mydocker-start="~/Path/to/start.sh"
```
Add these to the startup script of your favorite shell and you're all set.
```shell
nano ~/.bashrc
```

## Usage

### start.sh
Used to start the docker-container. It will automatically check your Viscosity-connection (when configured) and make sure the dns-settings are correct inside docker (when configured)
```shell
./start.sh
```

### exec.sh
Used to run a command inside the docker-container.
```shell
./exec.sh echo something
./exec.sh echo "something else"
./exec.sh "echo something && echo something else"
```

### stop.sh
Used to stop the docker-container. It also removes the cached docker-container (not the docker-image) to make sure that after a rebuild it uses the newly created docker-image.
```shell
./stop.sh
```

### restart.sh
Used to start and stop the docker-container.
```shell
./restart.sh
```

### build.sh
Used to (re)build the docker-image.
```shell
./build.sh
```
