#!/usr/bin/env bash

# exit immediately if any command fails
# andprint out commands before executing
set -ex

aptinstall="apt-get install -q -y --no-install-recommends"

function trim_comments() {
    egrep -v "(^#.*|^$)" "$1"
}

# The directory containing this script (portable)
DIR=$(dirname "$(readlink -f "$0")")

# install system packages
apt-get update

$aptinstall $(trim_comments "$DIR"/pre_deps.list)

"$DIR"/add_keys.sh
"$DIR"/add_sources.sh

apt-get update # needed again after adding new sources

# Kinetic for 16.04 and Melodic for 18.04
$aptinstall ros-"$ROS_DISTRO"-ros-base

$aptinstall $(trim_comments "$DIR"/post_deps.list)

# cleanup
apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
