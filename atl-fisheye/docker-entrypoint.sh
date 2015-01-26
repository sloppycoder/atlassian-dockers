#!/bin/bash
set -o errexit
umask 0027

if [ "$1" = "start" ]; then

    if [ ! -d  "$FISHEYE_INST" ]; then
        mkdir -p $FISHEYE_INST
    fi

    chown -R fisheye:fisheye $FISHEYE_INST

    if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
        CONTEXT_PATH=
    else
       CONTEXT_PATH="/$CONTEXT_PATH"
    fi

    FISHEYE_CONFIG=$FISHEYE_INST/config.xml
    if [ ! -f "$FISHEYE_CONFIG" ]; then
        xmlstarlet ed --insert "/config/web-server" --type attr -n context -v "$CONTEXT_PATH" \
              /opt/fecru-${FISHEYE_VERSION}/config.xml > $FISHEYE_CONFIG
        chown fisheye:fisheye $FISHEYE_CONFIG
    fi

    /opt/fecru-${FISHEYE_VERSION}/bin/start.sh
    exec tail -f /opt/atlassian-home/fisheye/var/log/fisheye.out
fi


exec "$@"



