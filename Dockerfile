FROM ubuntu:latest
LABEL maintainer Kyle Usbeck

# Need Git to checkout our sources
RUN apt-get update && apt-get install -y git

# Now grab ArduPilot from GitHub
RUN git clone https://github.com/ArduPilot/ardupilot.git ardupilot
WORKDIR ardupilot

# Checkout the latest Copter... maybe we can parameterize this?
RUN git checkout Copter-3.6.7

# Now start build instructions from http://ardupilot.org/dev/docs/setting-up-sitl-on-linux.html
RUN git submodule update --init --recursive

# Trick to get apt-get to not prompt for timezone in tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Need sudo and lsb-release for the installation prerequisites
RUN apt-get install -y sudo lsb-release tzdata

# Need USER set so usermod does not fail...
# Install all prerequisites now
RUN USER=nobody Tools/scripts/install-prereqs-ubuntu.sh -y

# Continue build instructions from https://github.com/ArduPilot/ardupilot/blob/master/BUILD.md
RUN ./waf distclean
RUN ./waf configure --board sitl
RUN ./waf copter
RUN ./waf rover 
RUN ./waf plane
RUN ./waf sub

# TCP 5760 is what the sim exposes by default
EXPOSE 5760/tcp

# Variables for simulator
ENV INSTANCE 0
ENV LAT 42.3898
ENV LON -71.1476
ENV ALT 14
ENV DIR 270
ENV MODEL +
ENV SPEEDUP 1
ENV VEHICLE arducopter

# Finally the command
ENTRYPOINT /ardupilot/build/sitl/bin/${VEHICLE} -S -I${INSTANCE} --home ${LAT},${LON},${ALT},${DIR} -w --model ${MODEL} --speedup ${SPEEDUP} --defaults /ardupilot/Tools/autotest/default_params/copter.parm
