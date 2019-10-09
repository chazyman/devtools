FROM ubuntu:xenial

RUN mkdir /tmp/dockerbuild
COPY . /tmp/dockerbuild

ENV ROS_DISTRO kinetic

RUN /tmp/dockerbuild/setup_system.sh

RUN rm -rf /tmp/dockerbuild
