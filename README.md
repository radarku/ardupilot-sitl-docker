ArduPilot Software-in-the-Loop Simulator Docker Container
=========================================================

The purpose of this is to run an ArduPilot SITL from within Docker.

How to build and run
--------------------

To build a docker image:

`docker build --tag ardupilot-sitl-docker github.com/radarku/ardupilot-sitl-docker`

To run the image:

`docker run -p 5761:5760 ardupilot`

This will start an ArduCopter SITL on host port 5761

