#!/usr/bin/env bash

# exit immediately if any command fails
# andprint out commands before executing
set -ex

function trim_comments() {
    egrep -v "(^#.*|^$)" "$1"
}

function install_list() {
    apt-get install -q -y --no-install-recommends $(trim_comments "$1")
}

# The directory containing this script (portable)
DIR=$(dirname "$(readlink -f "$0")")

# install system packages
apt-get update
install_list "$DIR"/pre_deps.list
"$DIR"/add_keys.sh
"$DIR"/add_sources.sh
apt-get update # needed again after adding new sources
install_list "$DIR"/post_deps.list

# cleanup
apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*
