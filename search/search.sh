#!/bin/bash

EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` {query string}"
  exit $E_BADARGS
fi

grep -r --exclude-dir=.git --color=auto "$*" .

