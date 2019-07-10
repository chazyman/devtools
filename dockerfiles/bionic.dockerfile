FROM ubuntu:bionic

RUN mkdir /tmp/dockerbuild
COPY . /tmp/dockerbuild

ENV ROS_DISTRO=melodic

# Issue with tzdata needing input to configure
ENV DEBIAN_FRONTEND=noninteractive

RUN /tmp/dockerbuild/setup_system.sh

RUN rm -rf /tmp/docker_install_dir
