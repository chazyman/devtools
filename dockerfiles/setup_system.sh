#!/usr/bin/env bash

# exit immediately if any command fails
# and print out commands before executing
set -ex

aptinstall="apt-get install -q -y --no-install-recommends"

function trim_comments() {
    grep -E -v "(^#.*|^$)" "$1"
}

# The directory containing this script (portable)
DIR=$(dirname "$(readlink -f "$0")")

# install system packages
apt-get update

$aptinstall $(trim_comments "$DIR"/deps/pre_deps.list)
$aptinstall $(trim_comments "$DIR"/deps/pre_"$(lsb_release -sc)".list)

"$DIR"/add_keys.sh
"$DIR"/add_sources.sh

apt-get update # needed again after adding new sources

# Kinetic for 16.04 and Melodic for 18.04
$aptinstall ros-"$ROS_DISTRO"-ros-base

$aptinstall ros-"$ROS_DISTRO"-ackermann-msgs
$aptinstall ros-"$ROS_DISTRO"-tf

$aptinstall $(trim_comments "$DIR"/deps/post_deps.list)


# cleanup
apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
