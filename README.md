# Docker orchestration of ROBOpop components

Scripts for running ROBOpop components in docker containers using docker-compose / docker swarm mode.

## Preparation
1. MacOS: install Docker for Mac
2. MacOS: install XQuartz (necessary for Ptolemy/silicon coppelia UI in Docker containers running on MacOS)
See [Wiki](https://github.com/robopop/docker/wiki/Ptolemy-GUI) for explanation


## Setup (recommended steps)
1. Clone this repository locally
2. If you haven't used docker compose before, run `docker swarm init`
3. Run `bin/create-local-settings.sh`
4. Edit credentials in `epistemics/etc/credentials-local.sh`

## Running
1. Change to directory `robopop`
2. Run `./docker-compose-up.sh`


### Alternative: Running with Ptolemy GUI
* If you use MacOS: run `./docker-compose-up.sh -v --gui -d "$(./osx-host.sh):0"`
* If you use Linux: run `./docker-compose-up.sh -v --gui`


## Accessing
If you run docker on a Linux system or as Docker for Mac, then the software will be available at:

* [Belief System Admin](http://localhost:8888/beliefsystem-webadmin/)
* [Mental World Admin](http://localhost:8888/mentalworld-webadmin/)
* [Mental World Web Application](http://localhost:8888/mentalworld-webapp/)
* [Silicon Coppélia](http://localhost:8084/)

As well as a REST service for the belief system:

* [Belief System REST service](http://localhost:8888/beliefsystem-rest/)

If you run docker in a virtual machine, you may need to replace `localhost` by the name or IP address of the virtual machine.

The belief system can be exported as a ZIP file using the Belief System Admin web application.
[This sample file](https://github.com/robopop/epistemics/raw/master/Installation/BeliefSystem.zip)
can be imported using the same web application.

The primary way to experiment with these software components is with the Ptolemy framework.
See the [Project Wiki](https://github.com/robopop/docker/wiki) for more information.
