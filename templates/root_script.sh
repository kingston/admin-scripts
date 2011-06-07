#!/bin/bash

# NAME: Rooted-Access Script 
# DESCRIPTION: Template for script requiring rooted access

EXPECTED_ARGS=1
E_BADARGS=65

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
fi

if [ $# -ne $EXPECTED_ARGS ]; then
    echo Usage: $0 arg1
    exit $E_BADARGS
fi

# Script goes here...
