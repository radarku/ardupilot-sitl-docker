ArduPilot Software-in-the-Loop Simulator Docker Container
=========================================================

The purpose of this is to run an ArduPilot SITL from within Docker.

Quick Start
-----------

To build a docker image:

`docker build --tag ardupilot-sitl-docker github.com/radarku/ardupilot-sitl-docker`

To run the image:

`docker run -p 5760:5760 ardupilot`

This will start an ArduCopter SITL on host TCP port 5761, so to connect to it from the host, you could:

`mavproxy.py --master=tcp:localhost:5760`

Options
-------

There are a number of options available to configure the simulator, for example, to run an ArduRover instance on port 5761, you could:

`docker run -p 5761:5760 --env VEHICLE=ardurover ardupilot`

We also have an example `env.list` file which can help you maintain your options and called like so:

`docker run -p 5761:5760 --env-file env.list ardupilot`

The full list of options and their default values is:

```
INSTANCE    0
LAT         42.3898
LON         -71.1476
ALT         14
DIR         270
MODEL       +
SPEEDUP     1
VEHICLE     arducopter
```

Vehicles and their corresponding models are listed below:

```
ArduCopter: octa-quad|tri|singlecopter|firefly|gazebo-
    iris|calibration|hexa|heli|+|heli-compound|dodeca-
    hexa|heli-dual|coaxcopter|X|quad|y6|IrisRos|octa
AntennaTracker: tracker
APMrover2: rover|gazebo-rover|rover-skid|calibration
ArduSub: vectored
ArduPlane: gazebo-zephyr|CRRCSim|last_letter|plane-
    vtail|plane|quadplane-tilttri|quadplane|quadplane-
    tilttrivec|calibration|plane-elevon|plane-
    tailsitter|plane-dspoilers|quadplane-tri
    |quadplane-cl84|jsbsim
```
