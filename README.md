ArduPilot Software-in-the-Loop Simulator Docker Container
=========================================================

The purpose of this is to run an ArduPilot SITL from within Docker.

DockerHub
---------

A pre-built Docker image is available on DockerHub at:

https://hub.docker.com/r/radarku/ardupilot-sitl

To download it, simply:

`docker pull radarku/ardupilot-sitl`
 
and to run it:

`docker run -it --rm -p 5760:5760 radarku/ardupilot-sitl`


Quick Start
-----------

If you'd rather build the docker image yourself:

`docker build --tag ardupilot github.com/radarku/ardupilot-sitl-docker`

You can now use the `--build-arg` option to specify which branch or tag in the ardupilot
repository you'd like to use. Here's an example:

`docker build --tag ardupilot --build-arg COPTER_TAG=Copter-4.0.1 github.com/radarku/ardupilot-sitl-docker`

If no COPTER_TAG is supplied, the build will use the default defined in the Dockerfile, currently set at Copter-4.0.3

To run the image:

`docker run -it --rm -p 5760:5760 ardupilot`

This will start an ArduCopter SITL on host TCP port 5760, so to connect to it from the host, you could:

`mavproxy.py --master=tcp:localhost:5760`

Options
-------

There are a number of options available to configure the simulator, for example, to run an ArduRover instance on port 5761, you could:

`docker run -it --rm -p 5761:5760 --env VEHICLE=APMRover2 ardupilot`

We also have an example `env.list` file which can help you maintain your options and called like so:

`docker run -it --rm -p 5761:5760 --env-file env.list ardupilot`

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

So, for example, you could issue a command such as:

```
docker run -it --rm -p 5761:5760 \
   --env VEHICLE=APMRover2 \
   --env MODEL=rover-skid \
   --env LAT=39.9656 \
   --env LON=-75.1810 \
   --env ALT=276 \
   --env DIR=180 \
   --env SPEEDUP=2 \
   ardupilot
```

Vehicles and their corresponding models are listed below:

```
ArduCopter: octa-quad|tri|singlecopter|firefly|gazebo-
    iris|calibration|hexa|heli|+|heli-compound|dodeca-
    hexa|heli-dual|coaxcopter|X|quad|y6|IrisRos|octa
APMRover2: rover|gazebo-rover|rover-skid|calibration
ArduSub: vectored
ArduPlane: gazebo-zephyr|CRRCSim|last_letter|plane-
    vtail|plane|quadplane-tilttri|quadplane|quadplane-
    tilttrivec|calibration|plane-elevon|plane-
    tailsitter|plane-dspoilers|quadplane-tri
    |quadplane-cl84|jsbsim
```
