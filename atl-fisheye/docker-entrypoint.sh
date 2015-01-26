#!/bin/bash
set -o errexit
umask 0022

if [ -z "$FISHEYE_INST" ]; then
  export FISHEYE_INST=/opt/atlassian-home/fisheye
  mkdir -p $FISHEYE_INST
fi
echo FISHEYE_INST set to $FISHEYE_INST

FISHEYE_CONFIG=$FISHEYE_INST/config.xml
if [ ! -f "$FISHEYE_CONFIG" ]; then
   cp /opt/fecru-${FISHEYE_VERSION}/config.xml $FISHEYE_INST/.
fi

/opt/fecru-${FISHEYE_VERSION}/bin/start.sh

exec "$@"



