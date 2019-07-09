FROM ubuntu:xenial

RUN mkdir /tmp/dockerbuild
COPY . /tmp/dockerbuild

RUN /tmp/dockerbuild/setup_system.sh

# cleanup --
RUN rm -rf /tmp/docker_install_dir
# --
