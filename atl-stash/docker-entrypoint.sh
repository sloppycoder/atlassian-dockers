#!/bin/bash

set -o errexit
umask 0027

if [ "$1" = "start" ]; then

    if [ ! -d "$STASH_HOME" ]; then
        mkdir -p $STASH_HOME
    fi

    chown -R stash:stash $STASH_HOME

    if [ "$CONTEXT_PATH" == "ROOT" -o -z "$CONTEXT_PATH" ]; then
        CONTEXT_PATH=
    else
        CONTEXT_PATH="/$CONTEXT_PATH"
    fi

    xmlstarlet ed -u '//Context/@path' -v "$CONTEXT_PATH" /opt/stash/conf/server-backup.xml > /opt/stash/conf/server.xml
    chown stash:stash  /opt/stash/conf/server.xml
    
    exec /usr/local/bin/gosu stash /opt/stash/bin/start-stash.sh -fg

fi


exec "$@"
