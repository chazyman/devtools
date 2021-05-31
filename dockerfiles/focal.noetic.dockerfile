FROM ros:noetic-ros-core

SHELL ["/bin/bash", "-c"]

# get ros packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    libyaml-cpp-dev \
    ros-noetic-nodelet \
    ros-noetic-xacro \
    ros-noetic-dynamic-reconfigure \
#    ros-noetic-serial \
    ros-noetic-ackermann-msgs \
    ros-noetic-tf \
    ros-noetic-nav-msgs \
    python3-rosdep \
    && rm -rf /var/lib/apt/lists/*

# get pythons and tools
RUN apt-get update && apt-get install --no-install-recommends -y \
	python3-dev \
#    git-core \
	python3-pip \
    build-essential autoconf automake gdb git libffi-dev zlib1g-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*


RUN pip3 install -U pip wheel

# install linting tools
#RUN pip3 install \
#	flake8==3.7.8 \
#	isort==4.3.21 \
#    matplotlib==2.2.4 \
#    vcstool==0.2.3 \
#    Cython \
#    black==19.3b0

RUN pip3 install \
	isort \
    matplotlib \
    vcstool \
    Cython \
    black

ENV PATH /opt/ros/noetic/bin:$PATH

RUN rosdep init && \
    rosdep update && \
    mkdir -p /catkin_ws/src

COPY repos.yaml /catkin_ws/

RUN cd /catkin_ws/ &&  vcs import src < repos.yaml

RUN source /opt/ros/noetic/setup.bash && cd /catkin_ws/src/range_libc && \
    mkdir build && cd build && \
    cmake .. -DWITH_CUDA=0 && \
    make && \
    make install && \
    cd /catkin_ws/src/range_libc/pywrapper && \
    python3 setup.py install && \
#    && python3 test.py
# Delete mushr non-simulation stuff or clean up temp source code 
    rm -rf /catkin_ws/src/range_libc && \
    rm -rf /catkin_ws/src/mushr/mushr_hardware/realsense/realsense2_camera && \
    rm -rf /catkin_ws/src/mushr/mushr_base/vesc && \
# Rviz config
    mkdir /.rviz && cp /catkin_ws/src/mushr/mushr_utils/rviz/default.rviz /.rviz/ && \
# build workspace
    cd /catkin_ws && \
    catkin_make

RUN chmod -R 777 /catkin_ws
    