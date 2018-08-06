Docker orchestration of ROBOpop components
==========================================

Scripts for running ROBOpop components in docker containers using docker-compose / docker swarm mode.

Recommended steps:

1. Run `bin/create-local-settings.sh`
2. Edit credentials in `epistemics/etc/credentials-local.sh`
3. Change to directory `robopop`
4. Run `./docker-compose-up.sh`

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