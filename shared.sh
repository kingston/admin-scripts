#!/bin/bash

# Contains shared functions that can be shared among all scripts

check_sudo() {
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root"
        exit 1
    fi
}

# Configuration

load_config() {
    if [ ! -f $1 ]; then
        echo "Unable to find configuration file at $1.  Goodbye!"
        exit 1
    fi

    source $1
}

function generate_random_password() {
    PASSWORD=`head /dev/urandom | sha1sum -b | cut -c1-15`
}

