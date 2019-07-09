FROM ubuntu:bionic

RUN mkdir /tmp/dockerbuild
COPY . /tmp/dockerbuild

RUN /tmp/dockerbuild/setup_system.sh

RUN rm -rf /tmp/docker_install_dir
