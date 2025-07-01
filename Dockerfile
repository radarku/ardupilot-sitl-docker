FROM ubuntu:20.04

ARG COPTER_TAG=ArduPilot-4.6

# install git 
RUN apt-get update && apt-get install -y git; git config --global url."https://github.com/".insteadOf git://github.com/

# Trick to get apt-get to not prompt for timezone in tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Need sudo and lsb-release for the installation prerequisites
RUN apt-get install -y sudo lsb-release tzdata

# Create the user and add to sudo group
RUN useradd --create-home --shell /bin/bash atlas \
 && usermod -aG sudo atlas \
 && echo 'atlas ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

 # Trick to get keyboard selection to not come up
RUN echo 'keyboard-configuration  keyboard-configuration/layoutcode select us' | sudo debconf-set-selections && \
echo 'keyboard-configuration  keyboard-configuration/modelcode select pc105' | sudo debconf-set-selections && \
sudo apt-get install keyboard-configuration -y

USER atlas
WORKDIR /home/atlas

# Now grab ArduPilot from GitHub
RUN git clone https://github.com/ArduPilot/ardupilot.git ardupilot
WORKDIR /home/atlas/ardupilot

# Checkout the latest Copter...
RUN git checkout ${COPTER_TAG}

# Now start build instructions from http://ardupilot.org/dev/docs/setting-up-sitl-on-linux.html
RUN git submodule update --init --recursive

# Install all prerequisites now
RUN USER=atlas DEBIAN_FRONTEND=noninteractive Tools/environment_install/install-prereqs-ubuntu.sh -y

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
ENV VEHICLE ArduCopter

#install maxproxy
RUN python3 -m pip install PyYAML mavproxy --user
ENV PATH="${PATH}:/home/atlas/.local/bin"

# Finally the command
ENTRYPOINT Tools/autotest/sim_vehicle.py --vehicle ${VEHICLE} -I${INSTANCE} --custom-location=${LAT},${LON},${ALT},${DIR} -w --frame ${MODEL} --no-rebuild --speedup ${SPEEDUP}
