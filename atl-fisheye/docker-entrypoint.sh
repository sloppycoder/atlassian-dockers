#!/bin/bash
set -o errexit
umask 0022

if [ -z "$FISHEYE_INST" ]; then
  export FISHEYE_INST=/opt/atlassian-home/fisheye
  mkdir -p $FISHEYE_INST
fi
echo FISHEYE_INST set to $FISHEYE_INST

if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
  CONTEXT_PATH=
else
  CONTEXT_PATH="/$CONTEXT_PATH"
fi

FISHEYE_CONFIG=$FISHEYE_INST/config.xml
if [ ! -f "$FISHEYE_CONFIG" ]; then
   xmlstarlet ed --insert "/config/web-server" --type attr -n context -v "$CONTEXT_PATH" \
              /opt/fecru-${FISHEYE_VERSION}/config.xml > $FISHEYE_CONFIG
fi

/opt/fecru-${FISHEYE_VERSION}/bin/start.sh

exec "$@"



