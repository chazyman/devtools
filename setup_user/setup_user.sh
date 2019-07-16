#!/usr/bin/env bash
# exit immediately if any command fails
# andprint out commands before executing
set -ex

# The directory containing this script (portable)
DIR=$(dirname "$(readlink -f "$0")")

# Conda (for python 3.6+ for black)
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /tmp > /dev/null
#bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b

export PATH="/home/$(whoami)/miniconda3/bin:$PATH"
echo 'export PATH="/home/$(whoami)/miniconda3/bin:$PATH"' >> ~/.bashrc

mkdir -p ~/.local/bin
#ln -s ~/miniconda3/bin/python3 ~/.local/bin/condapython3
echo 'export PATH="~/.local/bin:$PATH"' >> ~/.bashrc

rm -rf /tmp/Miniconda3-latest-Linux-x86_64.sh

# install python packages
# some installs fail with stock xenial pip version
python2 -m pip install wheel # needed or other installs break
python2 -m pip install -r "$DIR/python2_deps.list"
python3 -m pip install -r "$DIR/python3_deps.list"
# ~/miniconda3/bin/python3 -m pip install -r "$DIR/condapython3_deps.list"

# ROS
sudo rosdep init
rosdep update
echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
