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

$aptinstall $(trim_comments "$DIR"/deps/pre_deps.list)
$aptinstall $(trim_comments "$DIR"/deps/pre_"$(lsb_release -sc)".list)

"$DIR"/add_keys.sh
"$DIR"/add_sources.sh

apt-get update # needed again after adding new sources

# Kinetic for 16.04 and Melodic for 18.04
$aptinstall ros-"$ROS_DISTRO"-ros-base

$aptinstall $(trim_comments "$DIR"/deps/post_deps.list)
$aptinstall $(trim_comments "$DIR"/deps/post_"$(lsb_release -sc)".list)

# cleanup
apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# setup conda for linting
# useradd -ms /bin/bash miniconda

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p /opt/miniconda

chmod -R go-w /opt/miniconda
chmod -R go+rX /opt/miniconda

rm miniconda.sh

/opt/miniconda/bin/conda config --set always_yes yes --set changeps1 no
/opt/miniconda/bin/conda update -q conda
/opt/miniconda/bin/conda env create --file "$DIR"/lint-env.yaml
