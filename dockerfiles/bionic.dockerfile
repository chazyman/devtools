FROM ros:melodic-ros-core

SHELL ["/bin/bash", "-c"]

# get ros packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    libyaml-cpp-dev \
    ros-melodic-nodelet \
    ros-melodic-xacro \
    ros-melodic-dynamic-reconfigure \
    ros-melodic-serial \
    ros-melodic-ackermann-msgs \
    ros-melodic-tf \
    && rm -rf /var/lib/apt/lists/*

# get pythons and tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    vim \
	python-pip \
	python3.6 \
	python3-pip \
    && rm -rf /var/lib/apt/lists/*


RUN pip2 install wheel

# install linting tools
RUN pip2 install \
	flake8==3.7.8 \
	isort==4.3.21 \
    matplotlib==2.2.4 \
    vcstool==0.2.3

RUN pip3 install \
	black==19.3b0

ENV PATH /opt/ros/melodic/bin:$PATH

RUN source /opt/ros/melodic/setup.bash && \
    mkdir -p /catkin_ws/src && \
    cd /catkin_ws/src && \
    catkin_init_workspace

RUN source /opt/ros/melodic/setup.bash && \
    git clone https://github.com/prl-mushr/mushr.git /catkin_ws/src/mushr && \
    cd /catkin_ws/src && \
    vcs import < mushr/repos.yaml && \
    # Don't need the realsense for the container
    rm -rf mushr/mushr_hardware/realsense/realsense2_camera && \
    cd /catkin_ws && \
    catkin_make
