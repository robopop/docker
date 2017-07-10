Epistemics of the Virtual
=========================

Scripts for running ROBOpop component Epistemics of the Virtual in docker containers.

Recommended steps:

1. Run `bin/ensure-local.sh`
2. Edit credentials in `etc/*-local.sh`
3. Run `bin/docker-run.sh`

If you run docker on a Linux system or as Docker for Mac, then the software will be available at:

* [Belief System Admin](http://localhost:8888/beliefsystem-webadmin/)
* [Mental World Admin](http://localhost:8888/mentalworld-webadmin/)
* [Mental World Web Application](http://localhost:8888/mentalworld-webapp/)

As well as a REST service for the belief system:

* [Belief System REST service](http://localhost:8888/beliefsystem-rest/)

The belief system can be exported as a ZIP file using the Belief System Admin web application.
[This sample file](https://github.com/robopop/epistemics/raw/master/Installation/BeliefSystem.zip)
can be imported using the same web application.
