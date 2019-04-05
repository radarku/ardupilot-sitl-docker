FROM ubuntu:latest
LABEL maintainer Kyle Usbeck

RUN apt-get update && apt-get install -y git
#RUN apt-get update && apt-get install -y  \
#  git \
#  libtool-bin \
#  automake \
#  autoconf \
#  libexpat1-dev \
#  python-matplotlib \
#  python-serial \
#  python-wxgtk3.0 \
#  python-wxtools \
#  python-lxml \
#  python-scipy \
#  python-opencv \
#  ccache \
#  gawk \
#  python-pip \
#  python-pexpect \
#  htop
#RUN pip install future \
#  pymavlink \
#  MAVProxy \
#  simplejson \
#  pid \
#  cherrypy \
#  jinja2 \
#  dronekit \
#  dronekit-sitl -UI
RUN git clone https://github.com/ArduPilot/ardupilot.git ardupilot
#RUN git checkout `git tag -l | grep "Copter" | grep -v "Ardu" | sort | tail -n 1`
WORKDIR ardupilot
RUN git checkout Copter-3.6.7
RUN git submodule update --init --recursive
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y sudo lsb-release tzdata
RUN USER=nobody Tools/scripts/install-prereqs-ubuntu.sh -y
RUN ./waf distclean
RUN ./waf configure --board sitl
RUN ./waf copter

EXPOSE 5760
CMD ["/ardupilot/build/sitl/bin/arducopter", "-S", "-I0", "--home", "-35.363261,149.165230,584,353", "-w", "--model", "+", "--speedup", "1", "--defaults", "/ardupilot/Tools/autotest/default_params/copter.parm"]
